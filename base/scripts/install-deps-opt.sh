#!/bin/bash

set -e

printf "\n[-] Installing OPTIONAL dependencies...\n\n"

# install optional dependencies

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep APT_GET_INSTALL $APP_SOURCE_DIR/launchpad.conf)

  if [ "$APT_GET_INSTALL" ]; then
    printf "\n[-] Installing custom apt dependencies...\n\n"
    apt-get update
    apt-get install -y $APT_GET_INSTALL
  fi
fi
