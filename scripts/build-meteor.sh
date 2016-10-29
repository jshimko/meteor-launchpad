#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

printf "\n[-] Building Meteor application [Test-2]...\n\n"
COPIED_APP_PATH=/copied-app
cp -R $APP_SOURCE_DIR $COPIED_APP_PATH

cd $COPIED_APP_PATH

chown -R node $COPIED_APP_PATH
chmod -R 777 $COPIED_APP_PATH
# Install app deps
gosu node meteor npm install

# build the source
mkdir -p $APP_BUNDLE_DIR
chown -R node $APP_BUNDLE_DIR
# fix permissions
chmod -R 770 $APP_BUNDLE_DIR
gosu node meteor build --directory $APP_BUNDLE_DIR
cd $APP_BUNDLE_DIR/bundle/programs/server/
gosu node meteor npm install --production

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh

# clean up
rm -rf $COPIED_APP_PATH
