
# Default rule/target
.DEFAULT_GOAL := install

VERSION := $(shell uuidgen)
PROJECT := freegroup/thindexed-shapes


ifndef DOCKER_REPOSITORY
	DOCKER_REPOSITORY := docker.io
endif

IMAGE_NAME := $(DOCKER_REPOSITORY)/$(PROJECT):$(VERSION)

# Rule definitions
.PHONY: print-env
print-env:
	@echo $(VERSION)
	@echo $(PROJECT)
	@echo $(DOCKER_REPOSITORY)
	@echo $(IMAGE_NAME)

.PHONY: build
build:
	@echo "Building..."
	@docker build --no-cache=false --rm -t $(IMAGE_NAME) .
	docker push $(IMAGE_NAME)

.PHONY: install
install: build
	@echo "Deploying..."

	@cat ./deployments/deployment.tmpl | sed "s~<image-name>~$(IMAGE_NAME)~g" | kubectl apply -f -
