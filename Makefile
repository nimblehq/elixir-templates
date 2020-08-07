.PHONY: env_setup

env_setup: ## Setup development environment
	docker-compose -f docker-compose.dev.yml up -d
