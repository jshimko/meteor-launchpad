#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

printf "\n[-] Building Meteor application...\n\n"

# Set owner and permissions of source dir
chown -R node $APP_SOURCE_DIR
chmod -R 770 $APP_SOURCE_DIR

# Install app deps
gosu node meteor npm install

# create bundle dir and set owner and permissions
mkdir -p $APP_BUNDLE_DIR
chown -R node $APP_BUNDLE_DIR
chmod -R 770 $APP_BUNDLE_DIR

# build meteor bundle
gosu node meteor build --directory $APP_BUNDLE_DIR
cd $APP_BUNDLE_DIR/bundle/programs/server/
gosu node meteor npm install --production

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh
