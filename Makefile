.PHONY: docker_setup

docker_setup:
	docker-compose -f docker-compose.dev.yml up -d
