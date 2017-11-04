## v2.3.0

- Updates for Meteor 1.6 support
- Node 8.9.0
- Mongo 3.4.10

## v2.2.2

- Source NODE_VERSION from launchpad.conf if present

## v2.2.1

- Mongo 3.4.9
- add more verbosity to curl calls

## v2.2.0

- add ability to inject an NPM_TOKEN for installation of private packages
- update dockerignore
- add deploy.sh for pushing your built images to a Docker registry

## v2.1.3

- oh, CircleCI... your tag handling sucks sometimes

## v2.1.2

- update GPG key servers to use port 80 (fixes firewall issues for those that can't use non-standard ports)

## v2.1.1

- switch to building the image inside `docker:latest` on CircleCI

## v2.1.0

- use `--server-only` in `meteor build` to skip mobile platform builds
- Mongo 3.4.7
- update CircleCI Docker version

## v2.0.4

- support `APT_GET_INSTALL` from launchpad.conf

## v2.0.3

- add `apt-transport-https` for rare issue (most likely caused by apt source redirects) (#50)
- Node 4.8.4

## v2.0.2

- update CircleCI dependencies

## v2.0.0

- update to CircleCI 2.0 for the automated build/publish
- This update is a fairly big refactor of the Dockerfiles. It removes the shared base Dockerfile and switches to two totally separate builds - the original `devbuild` with every layer aggressively cached (for faster builds in development), and the lean production build with the bare minimum dependencies. Both builds support using `--build-arg` flags to customize what optional dependencies get installed (Mongo, Phantom, etc). The one potentially breaking change here is the `:devbuild` tag no longer supports the usage of the `launchpad.conf` config file because all dependencies are installed/cached before your app code (and config file) is even copied into the container. However, Mongo/Phantom/Graphicsmagick are all set to install by default now, and you can easily override that by running your app build with the following flags (note that this only applies to the devbuild base image - the lean `:latest` image doesn't have those installed unless you specify them with build args):

```sh
# to skip installing Mongo, Phantom, or Graphicsmagick
# when using jshimko/meteor-launchpad:devbuild

docker build \
  --build-arg INSTALL_MONGO=false \
  --build-arg INSTALL_PHANTOMJS=false \
  --build-arg INSTALL_GRAPHICSMAGICK=false \
  -t myorg/myapp:latest .
```

## v1.3.1

- fix issue when no launchpad.conf is found in devbuild

## v1.3.0

- set up all options as Docker build args and update documentation
- remove numactl


## v1.2.0

- allow setting TOOL_NODE_FLAGS for Meteor build at image build time (fixes #41)

Example usage:  
```
docker build --build-arg TOOL_NODE_FLAGS="--max-old-space-size=2048" -t myorg/myapp:latest .
```

## v1.1.8

- replace tar with bsdtar in Meteor installer (fixes #39) thanks @rsercano!


## v1.1.7

- Node 4.8.2
- Mongo 3.4.4


## v1.1.6

- Node 4.8.1
- Mongo 3.4.3


## v1.1.5

- Don't silence Meteor build output
- Update readme with details about creating a custom build
- Mongo 3.4.2
- Make sure Mongo is run by non-root user (if used at all)


## v1.1.4

- Node 4.7.3
- Mongo 3.4.1


## v1.1.2

- Node 4.6.2


## v1.1.1

- If internal Mongo is used, send it to the background (`--fork` required a logfile that would just keep getting larger indefinitely)
- Add default `MONGO_URL` for internal mongod (fixes #22)
- Move `$STARTUP_DELAY` after the mongod startup and add details to the readme
- Send the `meteor build` warning about building as root to /dev/null (since some people have assumed this is an error and the build can take a long time in larger apps).  The warning is irrelevant in this case because all permissions are updated after the build and the app is then run by a non-root user.


## v1.1.0

- update meteor build script to use `METEOR_ALLOW_SUPERUSER` in the build.  Discontinues support of Meteor 1.4.2.  Please update to Meteor 1.4.2.1 if you are currently on 1.4.2
- allow optional install of Graphicsmagick using launchpad.conf - Thanks @un1x86! (#20)
- update gosu to 1.10


## v1.0.0

- Add Docker build versioning to CI build.  Every tag in the form `vX.X.X` will now create and push a new build on CircleCI and update the `:latest` tag. You can now use `jshimko/meteor-launchpad:latest` to always use the latest, or you can pin a specific version with `jshimko/meteor-launchpad:v1.0.0`.  See all available builds here: https://hub.docker.com/r/jshimko/meteor-launchpad/tags/

This is also the last/only version of Meteor Launchpad to support Meteor 1.4.2.  The [issue with using Meteor commands as root](https://github.com/meteor/meteor/issues/7959) introduced in 1.4.2 caused a big problem for this image because it meant the build scripts would _only_ work for Meteor 1.4.2 or later (long story).  [This fix in 1.4.2.1](https://github.com/meteor/meteor/pull/7975/commits/e4acc36f63f98243237b5e6b3e46b083822b95fd) addresses that problem and now allows this image to support any version of Meteor >=1.3 (except 1.4.2 - which you should definitely upgrade if you are using it).
