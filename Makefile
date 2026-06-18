install:
	bash install.sh

update:
	git pull && bash install.sh

push:
	git diff --name-only | tr '\n' ' '
	git add -u && git commit -m "chore: sync dotfiles $$(date '+%Y-%m-%d')" && git push
