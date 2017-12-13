FROM ubuntu:16.04
MAINTAINER Nathan Trujillo <nathan.d.trujillo@gmail.com>

RUN groupadd -r node && useradd -m -g node node

# Gosu
ENV GOSU_VERSION 1.10

# MongoDB
ENV MONGO_VERSION 3.4.10
ENV MONGO_MAJOR 3.4
ENV MONGO_PACKAGE mongodb-org

# PhantomJS
ENV PHANTOM_VERSION 2.1.1

# build directories
ENV APP_SOURCE_DIR /opt/meteor/src
ENV APP_BUNDLE_DIR /opt/meteor/dist
ENV BUILD_SCRIPTS_DIR /opt/build_scripts

# Add entrypoint and build scripts
COPY scripts $BUILD_SCRIPTS_DIR
RUN chmod -R 750 $BUILD_SCRIPTS_DIR

# Define all --build-arg options
ONBUILD ARG APT_GET_INSTALL
ONBUILD ENV APT_GET_INSTALL $APT_GET_INSTALL

ONBUILD ARG NODE_VERSION
ONBUILD ENV NODE_VERSION ${NODE_VERSION:-8.9.0}

ONBUILD ARG NPM_TOKEN
ONBUILD ENV NPM_TOKEN $NPM_TOKEN

ONBUILD ARG INSTALL_MONGO
ONBUILD ENV INSTALL_MONGO $INSTALL_MONGO

ONBUILD ARG INSTALL_PHANTOMJS
ONBUILD ENV INSTALL_PHANTOMJS $INSTALL_PHANTOMJS

ONBUILD ARG INSTALL_GRAPHICSMAGICK
ONBUILD ENV INSTALL_GRAPHICSMAGICK $INSTALL_GRAPHICSMAGICK

# Node flags for the Meteor build tool
ONBUILD ARG TOOL_NODE_FLAGS
ONBUILD ENV TOOL_NODE_FLAGS $TOOL_NODE_FLAGS

# optionally custom apt dependencies at app build time
ONBUILD RUN if [ "$APT_GET_INSTALL" ]; then apt-get update && apt-get install -y $APT_GET_INSTALL; fi

# copy the app to the container
ONBUILD COPY . $APP_SOURCE_DIR
ONBUILD RUN ls -la $APP_SOURCE_DIR
## ONBUILD COPY .meteor $APP_SOURCE_DIR/.meteor

# install all dependencies, build app, clean up
ONBUILD WORKDIR $APP_SOURCE_DIR

ONBUILD RUN $BUILD_SCRIPTS_DIR/install-deps.sh
ONBUILD RUN $BUILD_SCRIPTS_DIR/install-node.sh
ONBUILD RUN $BUILD_SCRIPTS_DIR/install-phantom.sh
ONBUILD RUN $BUILD_SCRIPTS_DIR/install-graphicsmagick.sh
ONBUILD RUN $BUILD_SCRIPTS_DIR/install-mongo.sh


# setup a user to install and run meteor as
ONBUILD ENV METEOR_USER meteor
ONBUILD RUN echo N | apt-get install -y sudo
ONBUILD RUN $BUILD_SCRIPTS_DIR/add-user.sh $METEOR_USER
ONBUILD RUN echo "$METEOR_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
ONBUILD RUN chown -R $METEOR_USER $BUILD_SCRIPTS_DIR


ONBUILD RUN $BUILD_SCRIPTS_DIR/install-meteor.sh
# ONBUILD RUN su $METEOR_USER -m -c "sudo $BUILD_SCRIPTS_DIR/install-meteor.sh"
ONBUILD RUN $BUILD_SCRIPTS_DIR/build-meteor.sh
# ONBUILD RUN su $METEOR_USER -m -c "sudo $BUILD_SCRIPTS_DIR/build-meteor.sh"

ONBUILD RUN $BUILD_SCRIPTS_DIR/post-build-cleanup.sh

# put the entrypoint script in WORKDIR
ONBUILD RUN mv $BUILD_SCRIPTS_DIR/entrypoint.sh $APP_BUNDLE_DIR/bundle/entrypoint.sh
ONBUILD RUN ls -la $APP_BUNDLE_DIR/bundle/
ONBUILD RUN chown -R node:node $APP_BUNDLE_DIR


# Default values for Meteor environment variables
ENV ROOT_URL http://localhost
ENV MONGO_URL mongodb://127.0.0.1:27017/meteor
ENV PORT 3000

EXPOSE 3000

WORKDIR $APP_BUNDLE_DIR/bundle

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
