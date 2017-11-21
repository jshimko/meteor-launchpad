#!/bin/bash

set -e

if [ "$DEV_BUILD" = true ]; then
  # if this is a devbuild, we don't have an app to check the .meteor/release file yet,
  # so just install the latest version of Meteor
  printf "\n[-] Installing the latest version of Meteor...\n\n"
  curl -v https://install.meteor.com/ | sh
else

  # read in the release version in the app
  export METEOR_VERSION=$(head $APP_SOURCE_DIR/.meteor/release | cut -d "@" -f 2)

  # install
  printf "\n[-] Installing Meteor $METEOR_VERSION...\n\n"
  curl -v https://install.meteor.com/?release=$METEOR_VERSION | sh
fi
