.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

validate: ## Validates the template file to ensure there are no glaring errors
	@packer validate template.json

build-remote: validate ## Pushes to the remote builder, Atlas.
	@packer push template.json

build-local: validate ## Builds on the current machine via Virtualbox
	@packer build template.json
