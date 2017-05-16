FROM debian:jessie
MAINTAINER Jeremy Shimko <jeremy.shimko@gmail.com>

RUN groupadd -r node && useradd -m -g node node

ENV NODE_VERSION 4.8.2
ENV GOSU_VERSION 1.10

# Optionally Install MongoDB
ENV INSTALL_MONGO false
ENV MONGO_VERSION 3.4.4
ENV MONGO_MAJOR 3.4
ENV MONGO_PACKAGE mongodb-org

# Optionally Install PhantomJS
ENV INSTALL_PHANTOMJS false
ENV PHANTOM_VERSION 2.1.1

# Optionally Install Graphicsmagick
ENV INSTALL_GRAPHICSMAGICK false

# Optionally Install the listed apt-get packages
ENV INSTALL_APTGET_PACKAGES ""

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

# Default values for Meteor environment variables
ENV ROOT_URL http://localhost
ENV MONGO_URL mongodb://127.0.0.1:27017/meteor
ENV PORT 3000

EXPOSE 3000

WORKDIR $APP_BUNDLE_DIR/bundle

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
