FROM debian:jessie
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

ENV NODE_VERSION 4.6.1

# Optionally Install MongoDB
ENV INSTALL_MONGO false
ENV MONGO_VERSION 3.2.10
ENV MONGO_MAJOR 3.2

# Optionally Install PhantomJS
ENV INSTALL_PHANTOMJS false
ENV PHANTOM_VERSION 2.1.1

# build directories
ENV APP_SOURCE_DIR /opt/meteor/src
ENV APP_BUNDLE_DIR /opt/meteor/dist
ENV BUILD_SCRIPTS_DIR /opt/build_scripts

# Add entrypoint and build scripts
COPY scripts $BUILD_SCRIPTS_DIR
RUN chmod -R 770 $BUILD_SCRIPTS_DIR

# install base dependencies, build app, cleanup
RUN cd $BUILD_SCRIPTS_DIR && \
		bash $BUILD_SCRIPTS_DIR/install-deps.sh && \
		bash $BUILD_SCRIPTS_DIR/install-node.sh && \
		bash $BUILD_SCRIPTS_DIR/post-install-cleanup.sh

ENV PORT 80
EXPOSE 80

WORKDIR $APP_BUNDLE_DIR/bundle

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
