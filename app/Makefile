
.PHONY: build push deploy dev k8s

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

k8s:
	kompose convert -f docker-compose.yml -o k8s
	sed -i .bak '/type: Recreate/d' k8s/evercran-deployment.yaml
	sed -i .bak '/type: Recreate/d' k8s/db-deployment.yaml
	sed -i .bak 's/ReadOnlyMany/ReadWriteMany\n  storageClassName: azurefiles/' \
		k8s/packages2-persistentvolumeclaim.yaml
	rm k8s/*.bak
