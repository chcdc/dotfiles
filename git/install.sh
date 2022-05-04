#!/bin/bash

if [[ ! -x "$(command -v git)" ]]; then
    echo "Installing git"
	sudo apt install git
fi

echo "Creating gitignore file"
cp gitignore ~/.gitignore

echo "Configuring git"

# Editor
git config --global core.editor "nvim"

# Alias
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.ca "commit --amend"
git config --global alias.df "diff"
git config --global alias.dc "diff --cached"
git config --global alias.st "status"
git config --global alias.br "branch"
git config --global alias.cp "cherry-pick"
git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Core
git config --global core.excludesfile ~/.gitignore

# Init
git config --global init.defaultBranch main

