.PHONY: install update push help

.DEFAULT_GOAL := help

TIMESTAMP := $(shell date '+%Y-%m-%d %H:%M')
CHANGED    := $(shell git diff --name-only 2>/dev/null | tr '\n' ' ')

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  install   create symlinks via install.sh"
	@echo "  update    pull latest changes and re-run install"
	@echo "  push      commit changed files and push to origin"

install:
	bash install.sh

update:
	git pull --rebase && bash install.sh

push:
	@if [ -z "$(CHANGED)" ]; then echo "nothing to commit"; exit 0; fi
	git add -u
	git commit -m "chore: sync dotfiles $(TIMESTAMP) [$(CHANGED)]"
	git push

restore:
	bash install.sh restore
