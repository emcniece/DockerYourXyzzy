# Builds emcniece/pretendyourexyzzy

NAMESPACE := emcniece
PROJECT := dockeryourxyzzy
PLATFORM := linux
ARCH := amd64
DOCKER_IMAGE := $(NAMESPACE)/$(PROJECT)

VERSION := $(shell cat VERSION)
GITSHA := $(shell git rev-parse --short HEAD)

all: help

help:
	@echo "---"
	@echo "IMAGE: $(DOCKER_IMAGE)"
	@echo "VERSION: $(VERSION)"
	@echo "---"
	@echo "make image - compile Docker image"
	@echo "make run - start Docker contaner"
	@echo "make run-test - run 'npm test' on container"
	@echo "make run-debug - run container with tail"
	@echo "make docker - push to Docker repository"
	@echo "make release - push to latest tag Docker repository"

image:
	docker build -t $(DOCKER_IMAGE):$(VERSION) \
		-f Dockerfile .

image-base:
	docker build -t $(DOCKER_IMAGE):$(VERSION)-base \
		--target base \
		-f Dockerfile .
	docker tag $(DOCKER_IMAGE):$(VERSION)-base $(DOCKER_IMAGE):base

image-dev:
	docker build -t $(DOCKER_IMAGE):$(VERSION)-dev \
		--target dev \
		-f Dockerfile .
	docker tag $(DOCKER_IMAGE):$(VERSION)-dev $(DOCKER_IMAGE):dev

image-run:
	docker build -t $(DOCKER_IMAGE):$(VERSION)-run \
		--target run \
		-f Dockerfile .
	docker tag $(DOCKER_IMAGE):$(VERSION)-run $(DOCKER_IMAGE):run

run:
	docker run -d -p 8080:8080 $(DOCKER_IMAGE):$(VERSION)

run-test:
	docker run -d $(DOCKER_IMAGE):$(VERSION) npm test

run-debug:
	docker run -d $(DOCKER_IMAGE):$(VERSION) tail -f /dev/null

docker:
	@echo "Pushing $(DOCKER_IMAGE):$(VERSION)"
	docker push $(DOCKER_IMAGE):$(VERSION)

release: docker
	@echo "Pushing $(DOCKER_IMAGE):latest"
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):latest
