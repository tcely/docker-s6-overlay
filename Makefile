.EXPORT_ALL_VARIABLES:
S6_VERSION := v3.2.0.0

it: download

.PHONY: dockerhub
dockerhub:
	@bash dockerhub/README.sh

download:
	@docker buildx bake download --no-cache

build:
	@docker buildx bake build --print
