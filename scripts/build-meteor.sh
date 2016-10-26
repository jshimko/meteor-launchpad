#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

printf "\n[-] Building Meteor application...\n\n"

cd $APP_SOURCE_DIR

# Install app deps
meteor npm install --unsafe-perm

# build the source
mkdir -p $APP_BUNDLE_DIR
meteor build --unsafe-perm --directory $APP_BUNDLE_DIR
cd $APP_BUNDLE_DIR/bundle/programs/server/
meteor npm install --production --unsafe-perm

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh
