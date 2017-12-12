#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

# set up npm auth token if one is provided
if [[ "$NPM_TOKEN" ]]; then
  echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" >> ~/.npmrc
fi

# Fix permissions warning in Meteor >=1.4.2.1 without breaking
# earlier versions of Meteor with --unsafe-perm or --allow-superuser
# https://github.com/meteor/meteor/issues/7959
export METEOR_ALLOW_SUPERUSER=true

cd $APP_SOURCE_DIR

# Install app deps
printf "\n[-] Running npm install in app directory...\n\n"
rm -rf node_modules/
meteor reset
meteor npm install
meteor npm install flatten-packages
meteor npm run streamline
meteor npm uninstall flatten-packages
meteor npm install
meteor npm install --production

# build the bundle
printf "\n[-] Building Meteor application ...\n\n"
mkdir -p $APP_BUNDLE_DIR
##meteor build --directory $APP_BUNDLE_DIR --server-only
time METEOR_PROFILE=200 meteor build --directory $APP_BUNDLE_DIR --server-only


# run npm install in bundle
printf "\n[-] Running npm install in the server bundle...\n\n"
cd $APP_BUNDLE_DIR/bundle/programs/server/

meteor npm install --production
meteor npm dedupe
meteor npm install flatten-packages
./node_modules/flatten-packages/bin/flatten
meteor npm uninstall flatten-packages

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh

# change ownership of the app to the node user
chown -R node:node $APP_BUNDLE_DIR
