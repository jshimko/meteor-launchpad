FROM debian:jessie
MAINTAINER OpenMove team

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

RUN $BUILD_SCRIPTS_DIR/install-deps.sh

# Default values for Meteor environment variables
ENV ROOT_URL http://localhost
ENV MONGO_URL mongodb://127.0.0.1:27017/meteor
ENV PORT 3000

# EXPOSE 80

WORKDIR $APP_BUNDLE_DIR/bundle

# start the app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "main.js"]
