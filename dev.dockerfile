FROM jshimko/meteor-launchpad:base
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

ENV DEV_BUILD true

ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-meteor.sh
ONBUILD COPY . $APP_SOURCE_DIR
ONBUILD RUN $BUILD_SCRIPTS_DIR/build-meteor.sh

# optionally install Mongo or Phantom at app build time
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-phantom.sh
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-mongo.sh
