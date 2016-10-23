FROM debian:jessie
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

ENV NODE_VERSION "4.6.0"

# build directories
ENV APP_SOURCE_DIR "/opt/meteor/src"
ENV APP_BUNDLE_DIR "/opt/meteor/dist"
ENV APP_DIR "/opt/app"
ENV BUILD_SCRIPTS_DIR "/opt/build_scripts"

# Add entrypoint and build scripts
COPY scripts $BUILD_SCRIPTS_DIR
RUN chmod -R +x $BUILD_SCRIPTS_DIR

# install base dependencies, build app, cleanup
RUN cd $BUILD_SCRIPTS_DIR && \
		bash $BUILD_SCRIPTS_DIR/install-deps.sh && \
		bash $BUILD_SCRIPTS_DIR/install-node.sh && \
		bash $BUILD_SCRIPTS_DIR/setup-user.sh && \
		bash $BUILD_SCRIPTS_DIR/post-install-cleanup.sh

USER nodejs

EXPOSE 80

# start the app
ENTRYPOINT bash $BUILD_SCRIPTS_DIR/entrypoint.sh
CMD []
