setup:
	npm install
	cp utils/pre-commit.bash .git/hooks/pre-commit

dev:
	npx quartz build --serve
