FROM jshimko/meteor-launchpad:base
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

# allow setting Node flags for the Meteor build
ONBUILD ARG TOOL_NODE_FLAGS
ONBUILD ENV TOOL_NODE_FLAGS $TOOL_NODE_FLAGS

# copy the app to the container
ONBUILD COPY . $APP_SOURCE_DIR

# optionally install Mongo or Phantom at app build time
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-phantom.sh
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-mongo.sh
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-graphicsmagick.sh
ONBUILD RUN bash $BUILD_SCRIPTS_DIR/install-aptget-packages.sh

# install Meteor, build app, clean up
ONBUILD RUN cd $APP_SOURCE_DIR && \
            bash $BUILD_SCRIPTS_DIR/install-meteor.sh && \
            bash $BUILD_SCRIPTS_DIR/build-meteor.sh && \
            bash $BUILD_SCRIPTS_DIR/post-build-cleanup.sh
