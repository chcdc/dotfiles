#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date '+%Y%m%d_%H%M%S')"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${GREEN}[ok]${NC} $1"; }
warn()   { echo -e "${YELLOW}[warn]${NC} $1"; }
error()  { echo -e "${RED}[error]${NC} $1"; }

link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    warn "backup: $dst → $BACKUP_DIR/$(basename "$dst")"
  fi

  ln -sf "$src" "$dst"
  log "linked: $src → $dst"
}

declare -a LINKS=(
  "aliases/bash_aliases:$HOME/.bash_aliases"
  "git/gitconfig:$HOME/.gitconfig"
  "git/gitignore:$HOME/.gitignore"
  "nvim/init.vim:$HOME/.config/nvim/init.vim"
  "tmux/tmux.conf:$HOME/.tmux.conf"
  "zsh/zshrc:$HOME/.zshrc"
)

if [[ -d "$DOTFILES_DIR/bin" ]]; then
  mkdir -p "$HOME/bin"
  for script in "$DOTFILES_DIR/bin/"*; do
    [[ -f "$script" ]] || continue
    name="$(basename "$script")"
    link "$script" "$HOME/bin/$name"
    chmod +x "$HOME/bin/$name"
  done
fi

for entry in "${LINKS[@]}"; do
  src="$DOTFILES_DIR/${entry%%:*}"
  dst="${entry##*:}"

  if [[ ! -f "$src" ]]; then
    warn "Not found, skipping: $src"
    continue
  fi

  link "$src" "$dst"
done

SHELL_RC=""
if [[ -f "$HOME/.zshrc" ]]; then
  SHELL_RC="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
  SHELL_RC="$HOME/.bashrc"
fi

if [[ -n "$SHELL_RC" ]] && ! grep -q 'HOME/bin' "$SHELL_RC"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
  log "PATH updated in $SHELL_RC"
fi

echo ""
log "Done."
[[ -d "$BACKUP_DIR" ]] && warn "backups em: $BACKUP_DIR"
