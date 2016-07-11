#!/bin/bash
set -e

printf "\n[-] Performing final cleanup...\n"

# Clean out docs
rm -rf /usr/share/{doc,doc-base,man,locale,zoneinfo}

# Clean out package management dirs
rm -rf /var/lib/{cache,log}

# remove source
rm -rf $APP_SOURCE_DIR

# remove meteor
rm -rf /usr/local/bin/meteor
rm -rf /root/.meteor

# clean additional files created outside the source tree
rm -rf /root/{.npm,.cache,.config,.cordova,.local}
rm -rf /tmp/*

# remove npm
npm cache clean
rm -rf /opt/nodejs/bin/npm
rm -rf /opt/nodejs/lib/node_modules/npm/

# locale cleanup
cp -R /usr/share/locale/en\@* /tmp/
rm -rf /usr/share/locale/*
mv /tmp/en\@* /usr/share/locale/

# remove os dependencies
apt-get -y purge ca-certificates curl git bzip2
apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean
rm -rf /var/lib/apt/lists/*
