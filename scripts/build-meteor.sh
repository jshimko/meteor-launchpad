#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

printf "\n[-] Building Meteor application...\n\n"

cd $APP_SOURCE_DIR

chown -R node $APP_SOURCE_DIR

# Install app deps
gosu node meteor npm install

# build the source
mkdir -p $APP_BUNDLE_DIR
chown -R node $APP_BUNDLE_DIR
gosu node meteor build --directory $APP_BUNDLE_DIR
cd $APP_BUNDLE_DIR/bundle/programs/server/
gosu node meteor npm install --production

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh
