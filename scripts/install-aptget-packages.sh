#!/bin/bash

set -e

if [ -f $APP_SOURCE_DIR/launchpad.conf ]; then
  source <(grep INSTALL_APTGET_PACKAGES $APP_SOURCE_DIR/launchpad.conf)
fi

if [ ! -z "$INSTALL_APTGET_PACKAGES" ]; then
  PACKAGES=${INSTALL_APTGET_PACKAGES//:/$' '}
  printf "\n[-] Installing additional apt-get packages: ${PACKAGES}...\n\n"

  apt-get update -y
  apt-get install -y ${PACKAGES}
fi
