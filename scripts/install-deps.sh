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

apt-get install -y --no-install-recommends curl bzip2 libarchive-tools build-essential python git wget  gnupg2 dirmngr


# install gosu

dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"

wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"
wget -O /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh

export GNUPGHOME="$(mktemp -d)"

#gpg --keyserver hkps://hkps.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
#gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu

rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc

chmod +x /usr/local/bin/gosu /usr/local/bin/wait-for-it.sh

gosu nobody true

apt-get purge -y --auto-remove wget

