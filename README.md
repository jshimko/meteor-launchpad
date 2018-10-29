[![Circle CI](https://circleci.com/gh/jshimko/meteor-launchpad/tree/master.svg?style=svg)](https://circleci.com/gh/jshimko/meteor-launchpad/tree/master)
# Meteor Launchpad - Base Docker Image for Meteor Apps

### Build

Add the following to a `Dockerfile` in the root of your app:

```Dockerfile
FROM jshimko/meteor-launchpad:latest
```

Then you can build the image with:

```sh
docker build -t yourname/app .
```

**Setting up a .dockerignore file**

There are several parts of a Meteor development environment that you don't need to pass into a Docker build because a complete production build happens inside the container.  For example, you don't need to pass in your `node_modules` or the local build files and development database that live in `.meteor/local`.  To avoid copying all of these into the container, here's a recommended starting point for a `.dockerignore` file to be put into the root of your app.  Read more: https://docs.docker.com/engine/reference/builder/#dockerignore-file

```
.git
.meteor/local
node_modules
```

### Run

Now you can run your container with the following command...
(note that the app listens on port 3000 because it is run by a non-root user for [security reasons](https://github.com/nodejs/docker-node/issues/1) and [non-root users can't run processes on port 80](http://stackoverflow.com/questions/16573668/best-practices-when-running-node-js-with-port-80-ubuntu-linode))

```sh
docker run -d \
  -e ROOT_URL=http://example.com \
  -e MONGO_URL=mongodb://url \
  -e MONGO_OPLOG_URL=mongodb://oplog_url \
  -e MAIL_URL=smtp://mail_url.com \
  -p 80:3000 \
  yourname/app
```

#### Delay startup

If you need to force a delay in the startup of the Node process (for example, to wait for a database to be ready), you can set the `STARTUP_DELAY` environment variable to any number of seconds.  For example, to delay starting the app by 10 seconds, you would do this:

```sh
docker run -d \
  -e ROOT_URL=http://example.com \
  -e MONGO_URL=mongodb://url \
  -e STARTUP_DELAY=10 \
  -p 80:3000 \
  yourname/app
```

### Build Options

Meteor Launchpad supports setting custom build options in one of two ways.  You can either create a launchpad.conf config file in the root of your app or you can use [Docker build args](https://docs.docker.com/engine/reference/builder/#arg).  The currently supported options are to install PhantomJS, GraphicsMagick, MongoDB, or any list of `apt-get` dependencies (Meteor Launchpad is built on `debian:jesse`).  

If you choose to install Mongo, you can use it by _not_ supplying a `MONGO_URL` when you run your app container.  The startup script will then start Mongo inside the container and tell your app to use it.  If you _do_ supply a `MONGO_URL`, Mongo will not be started inside the container and the external database will be used instead.

Note that having Mongo in the same container as your app is just for convenience while testing/developing.  In production, you should use a separate Mongo deployment or at least a separate Mongo container.

Here are examples of both methods of setting custom options for your build:

**Option #1 - launchpad.conf**

To use any of them, create a `launchpad.conf` in the root of your app and add any of the following values.

```sh
# launchpad.conf

# Use apt-get to install any additional dependencies
# that you need before your building/running your app
# (default: undefined)
APT_GET_INSTALL="curl git wget"

# Install a custom Node version (default: latest 8.x)
NODE_VERSION=8.9.0

# Installs the latest version of each (default: all false)
INSTALL_MONGO=true
INSTALL_PHANTOMJS=true
INSTALL_GRAPHICSMAGICK=true
```

**Option #2 - Docker Build Args**

If you prefer not to have a config file in your project, your other option is to use the Docker `--build-arg` flag.  When you build your image, you can set any of the same values above as a build arg.

```sh
docker build \
  --build-arg APT_GET_INSTALL="curl git wget" \
  --build-arg INSTALL_MONGO=true \
  --build-arg NODE_VERSION=8.9.0 \
  -t myorg/myapp:latest .
```

## Installing Private NPM Packages

You can provide your [NPM auth token](http://blog.npmjs.org/post/118393368555/deploying-with-npm-private-modules) with the `NPM_TOKEN` build arg.

```sh
docker build --build-arg NPM_TOKEN="<your token>" -t myorg/myapp:latest .
```

## Development Builds

You can optionally avoid downloading Meteor every time when building regularly in development.  Add the following to your Dockerfile instead...

```Dockerfile
FROM jshimko/meteor-launchpad:devbuild
```

This isn't recommended for your final production build because it creates a much larger image, but it's a bit of a time saver when you're building often in development.  The first build you run will download/install Meteor and then every subsequent build will be able to skip that step and just build the app.

## Meteor.settings

If you want to include custom settings (as you would via a [settings.json file](https://docs.meteor.com/api/core.html#Meteor-settings)), you need to set the METEOR_SETTINGS environment variable:

```sh
docker run -d \
  -e ROOT_URL=http://example.com \
  -e MONGO_URL=mongodb://url \
  -e MONGO_OPLOG_URL=mongodb://oplog_url \
  -e MAIL_URL=smtp://mail_url.com \
  -e METEOR_SETTINGS="$(cat settings.json)" \
  -p 80:3000 \
  yourname/app
```

## Docker Compose

Add a `docker-compose.yml` to the root of your project with the following content and edit the app image name to match your build name.  Everything else should work as-is.

```yaml
# docker-compose.yml

app:
  image: yourname/app
  ports:
    - "80:3000"
  links:
    - mongo
  environment:
    - ROOT_URL=http://example.com
    - MONGO_URL=mongodb://mongo:27017/meteor

mongo:
  image: mongo:latest
  command: mongod --storageEngine=wiredTiger
```

And then start the app and database containers with...

```sh
docker-compose up -d
```

## Custom Builds of Meteor Launchpad

If you'd like to create a custom build for some reason, you can use the `build.sh` script in the root of the project to run all of the necessary commands.

First, make any changes you want, then to create your custom build:

```sh
# builds as jshimko/meteor-launchpad:latest
./build.sh
```

## License

MIT License

Copyright (c) 2017 Jeremy Shimko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
