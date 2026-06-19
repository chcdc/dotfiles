#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE="$HOME/.dotfiles_backup"
BACKUP_DIR="$BACKUP_BASE/$(date '+%Y%m%d_%H%M%S')"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${GREEN}[ok]${NC} $1"; }
warn()   { echo -e "${YELLOW}[warn]${NC} $1"; }
error()  { echo -e "${RED}[error]${NC} $1"; }

declare -a LINKS=(
  "aliases/bash_aliases:$HOME/.bash_aliases"
  "git/gitconfig:$HOME/.gitconfig"
  "git/gitignore:$HOME/.gitignore"
  "nvim/init.vim:$HOME/.config/nvim/init.vim"
  "tmux/tmux.conf:$HOME/.tmux.conf"
  "zsh/zshrc:$HOME/.zshrc"
)

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

restore() {
  if [[ ! -d "$BACKUP_BASE" ]]; then
    error "No backup found in $BACKUP_BASE"
    exit 1
  fi

  local last
  last=$(ls -1t "$BACKUP_BASE" | head -n1)

  if [[ -z "$last" ]]; then
    error "No backup found"
    exit 1
  fi

  local backup_path="$BACKUP_BASE/$last"
  warn "Restoring backup: $backup_path"

  for file in "$backup_path"/.[!.]* "$backup_path"/*; do
    [[ -e "$file" ]] || continue
    local name
    name="$(basename "$file")"

    local dst=""
    for entry in "${LINKS[@]}"; do
      local candidate="${entry##*:}"
      if [[ "$(basename "$candidate")" == "$name" ]]; then
        dst="$candidate"
        break
      fi
    done

    [[ -z "$dst" ]] && dst="$HOME/$name"
    [[ -L "$dst" ]] && rm "$dst"
    cp "$file" "$dst"
    log "Restored: $file → $dst"
  done

  echo ""
  log "Restore completed from: $backup_path"
}

install() {
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
      warn "Not found, skipping: $src..."
      continue
    fi

    link "$src" "$dst"
  done

  local shell_rc=""
  if [[ -f "$HOME/.zshrc" ]]; then
    shell_rc="$HOME/.zshrc"
  elif [[ -f "$HOME/.bashrc" ]]; then
    shell_rc="$HOME/.bashrc"
  fi

  if [[ -n "$shell_rc" ]] && ! grep -q 'HOME/bin' "$shell_rc"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$shell_rc"
    log "Updated PATH in $shell_rc"
  fi

  echo ""
  log "Done."
  [[ -d "$BACKUP_DIR" ]] && warn "Backups: $BACKUP_DIR"
}

case "${1:-install}" in
  install) install ;;
  restore) restore ;;
  *)
    error "Use: $0 [install|restore]"
    exit 1
    ;;
esac
