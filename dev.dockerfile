FROM jshimko/meteor-launchpad:base
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

ENV DEV_BUILD true

# allow setting Node flags for the Meteor build
ONBUILD ARG TOOL_NODE_FLAGS
ONBUILD ENV TOOL_NODE_FLAGS $TOOL_NODE_FLAGS

ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-meteor.sh
ONBUILD COPY . $APP_SOURCE_DIR
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/build-meteor.sh

# optionally install Mongo or Phantom at app build time
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-phantom.sh
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-mongo.sh
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-graphicsmagick.sh
