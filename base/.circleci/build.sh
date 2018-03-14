#!/bin/bash

set -e

IMAGE_NAME=${DOCKER_IMAGE_NAME:-"jshimko/meteor-launchpad"}

# build the latest
docker build -f dev.dockerfile -t $IMAGE_NAME:devbuild .
docker build -t $IMAGE_NAME:latest .
