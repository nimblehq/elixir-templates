.PHONY: envsetup

# Setup development environment
envsetup:
	docker-compose -f docker-compose.dev.yml up -d
