#!/bin/bash

docker build -t jshimko/meteor-launchpad:base .
docker build -f dev.dockerfile -t jshimko/meteor-launchpad:devbuild .
docker build -f prod.dockerfile -t jshimko/meteor-launchpad:latest .
