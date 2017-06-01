#!/bin/bash

set -x

# get curl
apt-get update
apt-get install -y curl

# install Docker client
curl -L -o /tmp/docker-$DOCKER_VERSION.tgz https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz
tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz
mv /tmp/docker/* /usr/bin
