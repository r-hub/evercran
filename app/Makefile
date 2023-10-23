
.PHONY: build push deploy dev

build:
	docker compose build

push:
	docker compose push

deploy:
	docker stack deploy \
		--compose-file=docker-compose.yml evercran

dev:
	docker stack deploy \
		--compose-file=docker-compose.yml \
		--compose-file=docker-compose-dev.yml \
		evercran

dev-config:
	@docker stack config \
		--compose-file=docker-compose.yml \
		--compose-file=docker-compose-dev.yml
