#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

printf "\n[-] Building Meteor application...\n\n"

cd $APP_SOURCE_DIR

# Install app deps
meteor npm install --production --unsafe-perm

# build the source
mkdir -p $APP_BUNDLE_DIR
meteor build --directory $APP_BUNDLE_DIR
cd $APP_BUNDLE_DIR/bundle/programs/server/
meteor npm install --production

mv $APP_BUNDLE_DIR/bundle $APP_DIR
rm -rf $APP_BUNDLE_DIR
