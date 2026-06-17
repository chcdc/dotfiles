# Dotfiles

Personal configuration files for Linux and macOS, organized by category and managed via `install.sh` using symlinks.

## Structure

```
dotfiles/
├── aliases/
│   └── bash_aliases        → ~/.bash_aliases
├── git/
│   ├── gitconfig           → ~/.gitconfig
│   └── gitignore           → ~/.gitignore
├── nvim/
│   └── init.vim            → ~/.config/nvim/init.vim
├── tmux/
│   └── tmux.conf           → ~/.tmux.conf
├── zsh/
│   └── zshrc               → ~/.zshrc
├── bin/                    → ~/bin/ (personal scripts)
└── install.sh
```

## Setup on a new machine

```bash
git clone git@github.com:chcdc/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The script creates symlinks from each file to the correct path under `$HOME`. Existing files are moved to `~/.dotfiles_backup/<timestamp>/` before being replaced.

## Keeping it up to date

Changes made directly to files in `$HOME` are already reflected in the repo (they're symlinks). To push updates:

```bash
cd ~/dotfiles
git add -u
git commit -m "chore: update <file>"
git push
```

To sync on another machine:

```bash
cd ~/dotfiles
git pull
```

## Adding new dotfiles

1. Copy the file to the corresponding folder in the repo:
   ```bash
   cp ~/.config/starship.toml ~/dotfiles/starship/starship.toml
   ```

2. Add the entry to the `LINKS` array in `install.sh`:
   ```bash
   "starship/starship.toml:$HOME/.config/starship.toml"
   ```

3. Re-run `install.sh` to create the symlink:
   ```bash
   bash ~/dotfiles/install.sh
   ```

4. Commit and push:
   ```bash
   cd ~/dotfiles
   git add .
   git commit -m "feat: add starship config"
   git push
   ```

## Environment variables and secrets

| File | Versioned | Purpose |
|---|---|---|
| `~/.env` | yes | generic variables, no sensitive values |
| `~/.env.local` | no | real secrets, tokens, credentials |

Load them in `.zshrc` or `.bashrc`:

```bash
[[ -f "$HOME/.env" ]]       && source "$HOME/.env"
[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"
```

Create `.env.local` manually on each new machine:

```bash
touch ~/.env.local && chmod 600 ~/.env.local
```

**Never version:** `~/.ssh/id_*`, `~/.env.local`, files containing tokens or passwords.

## Other resources

- [Boilerplates](https://github.com/chcdc/boilerplates) — templates for Docker, K8S, Ansible, Terraform, etc.
