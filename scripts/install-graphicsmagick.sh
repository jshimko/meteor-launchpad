#!/bin/bash

set -e

if [ "$INSTALL_GRAPHICSMAGICK" = true ]; then
  printf "\n[-] Installing Graphicsmagick...\n\n"

  apt-get update
  apt-get install -y graphicsmagick graphicsmagick-imagemagick-compat 
fi
