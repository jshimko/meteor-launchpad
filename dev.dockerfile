FROM jshimko/meteor-launchpad:base
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

ENV DEV_BUILD "true"

ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-meteor.sh
ONBUILD COPY . $APP_SOURCE_DIR
ONBUILD RUN $BUILD_SCRIPTS_DIR/build-meteor.sh
