#!/bin/bash

#
# builds a production meteor bundle directory
#
set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep TOOL_NODE_FLAGS $APP_SOURCE_DIR/launchpad.conf)
fi

# set up npm auth token if one is provided
if [[ "$NPM_TOKEN" ]]; then
  echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" >> ~/.npmrc
fi

# Fix permissions warning in Meteor >=1.4.2.1 without breaking
# earlier versions of Meteor with --unsafe-perm or --allow-superuser
# https://github.com/meteor/meteor/issues/7959
export METEOR_ALLOW_SUPERUSER=true

cd $APP_SOURCE_DIR

printf "\n[-] Activate conda in app directory...\n\n"

source /opt/conda/etc/profile.d/conda.sh

NODE_VERSION=$(node -v | cut -c2-)

echo "\nNODE_VERSION: ${NODE_VERSION}\n\n"

if [[ "$(echo "$NODE_VERSION" | cut -d'.' -f1)" -gt 14 ]]; then
  PYTHON_VERSION=3.12.2
else
  PYTHON_VERSION=2.7.18
fi

echo "\PYTHON_VERSION: ${PYTHON_VERSION}\n\n"

conda create --name py python=${PYTHON_VERSION} -y
conda activate py

echo "\n[-] Check python version on build...\n\n"
echo `python --version`

# Install app deps
printf "\n[-] Running npm install in app directory...\n\n"
meteor npm ci

# build the bundle
printf "\n[-] Building Meteor application...\n\n"
mkdir -p $APP_BUNDLE_DIR
meteor build --directory $APP_BUNDLE_DIR --server-only

# run npm install in bundle
printf "\n[-] Running npm install in the server bundle...\n\n"
cd $APP_BUNDLE_DIR/bundle/programs/server/
meteor npm install --production --verbose

# put the entrypoint script in WORKDIR
mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh

# change ownership of the app to the node user
chown -R node:node $APP_BUNDLE_DIR
