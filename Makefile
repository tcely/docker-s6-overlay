it: download

.PHONY: dockerhub
dockerhub:
	@bash dockerhub/README.sh

download:
	@docker buildx bake download --no-cache

build:
	@docker buildx bake build --print
