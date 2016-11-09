#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep INSTALL_GRAPHICSMAGICK $APP_SOURCE_DIR/launchpad.conf)
fi

if [ "$INSTALL_GRAPHICSMAGICK" = true ]; then
  printf "\n[-] Installing Graphicsmagick...\n\n"

  apt-get update
  apt-get install -y graphicsmagick graphicsmagick-imagemagick-compat 
fi
