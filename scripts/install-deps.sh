#!/bin/bash

set -e

printf "\n[-] Installing base OS dependencies...\n\n"

# install base dependencies

apt-get update

# ensure we can get an https apt source if redirected
# https://github.com/jshimko/meteor-launchpad/issues/50
apt-get install -y apt-transport-https ca-certificates

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep APT_GET_INSTALL $APP_SOURCE_DIR/launchpad.conf)

  if [ "$APT_GET_INSTALL" ]; then
    printf "\n[-] Installing custom apt dependencies...\n\n"
    apt-get install -y $APT_GET_INSTALL
  fi
fi

apt-get install -y --no-install-recommends curl bzip2 bsdtar build-essential python git gnupg gosu
