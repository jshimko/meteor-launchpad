#!/bin/bash

set -e

IMAGE_NAME=${1:-"jshimko/meteor-launchpad"}

printf "\n[-] Building $IMAGE_NAME...\n\n"

docker build --no-cache -f dev.dockerfile -t $IMAGE_NAME:devbuild .
docker build --no-cache -t $IMAGE_NAME:latest .
