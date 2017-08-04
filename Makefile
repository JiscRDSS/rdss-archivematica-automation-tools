
DEFAULT_GOAL := build

IMAGE_TAG_NAME ?= "arkivum/archivematica-automation-tools"
IMAGE_TAG_VERSION ?= "latest"

all: build

build: build-image-automation-tools

build-image-automation-tools:
	docker build -t "$(IMAGE_TAG_NAME):$(IMAGE_TAG_VERSION)" .

