include .env
export OBSIDIAN_CONTENT_PATH

SHELL := /bin/bash


setup:
	npm install
	cp utils/pre-commit.bash .git/hooks/pre-commit

copy:
	rm -rf content
	cp -r $(OBSIDIAN_CONTENT_PATH) content

dev: copy
	npx quartz build --serve

sync: copy
 	npx quartz sync

update:
	npx quartz update
