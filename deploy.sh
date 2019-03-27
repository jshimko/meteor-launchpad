#!/bin/bash

set -e

# Example usage:
# deploy.sh tradedepot/meteor-launchpad v1.0.0

IMAGE_NAME=$1 # tradedepot/meteor-launchpad
VERSION=$2    # v1.0.0

# create versioned tags
docker tag $IMAGE_NAME:devbuild $IMAGE_NAME:$VERSION-devbuild
docker tag $IMAGE_NAME:latest $IMAGE_NAME:$VERSION

# push the builds
docker push $IMAGE_NAME:$VERSION-devbuild
docker push $IMAGE_NAME:devbuild
docker push $IMAGE_NAME:$VERSION
docker push $IMAGE_NAME:latest
