#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep INSTALL_NODEGYP $APP_SOURCE_DIR/launchpad.conf)
fi

if [ "$INSTALL_NODEGYP" = true ]; then
  printf "\n[-] Installing node-gyp ...\n\n"
  npm install -g node-gyp
fi
