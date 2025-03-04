
.PHONY: help dev build test
help:
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dev: ## Starts application in development mode
	@gleam run -m lustre/dev start

build: ## Builds application for production
	@gleam run -m lustre/dev build

test: ## Runs all tests in watch mode
	@watchexec --restart --wrap-process=session -e gleam "gleam test"
