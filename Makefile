.PHONY: help build dev test lint shards console reset env

IMAGE_NAME := crystal-iso8583
IMAGE_TAG  := dev
FULL_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

define dc
	docker compose $(1)
endef

define dct
	docker compose -f docker-compose.test.yml $(1)
endef

define dc-run
	$(call dc, run --rm cmd -c "$(1)")
endef

define dc-exec
	$(call dc, exec $(1))
endef

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

env: ## Create env files from template if they don't exist
	@[ -f .env-dev ] || cp .env-dev.template .env-dev
	@[ -f .env-test ] || touch .env-test

build: env ## Build the Docker image
	@docker images -q $(FULL_IMAGE) | grep -q . || docker build -f Dockerfile.dev -t $(FULL_IMAGE) .

dev: build ## Launch development environment
	$(call dc, up)

test: build ## Run test suite
	$(call dct, run --rm cmd -c "crystal spec spec/")

lint: build ## Run formatter check
	$(call dc-run, crystal tool format --check src/ spec/)

shards: build ## Install shards (dependencies)
	$(call dc-run, shards install)

console: build ## Open bash console in container
	$(call dc, run --rm console)

reset: ## Remove image and rebuild from scratch
	docker rmi -f $(FULL_IMAGE) || true
	$(MAKE) build
