#!/bin/bash

set -e

if [ "$DEV_BUILD" = true ]; then
  # if this is a devbuild, we don't have an app to check the .meteor/release file yet,
  # so just install the latest version of Meteor
  curl https://install.meteor.com/ | sed 's:$HOME:/home/node:g' | sh
else
  # download installer script
  curl https://install.meteor.com -o /home/node/install_meteor.sh

  # read in the release version in the app
  METEOR_VERSION=$(head $APP_SOURCE_DIR/.meteor/release | cut -d "@" -f 2)

  # set the release version in the install script
  sed -i.bak "s/RELEASE=.*/RELEASE=\"$METEOR_VERSION\"/g" /home/node/install_meteor.sh

  # hard code the home directory for the Node user instead of using $HOME
  sed -i.bak 's:$HOME:/home/node:g' /home/node/install_meteor.sh

  # install
  printf "\n[-] Installing Meteor $METEOR_VERSION...\n\n"
  sh /home/node/install_meteor.sh
fi

# fix permissions
chown -R node /home/node/.meteor
