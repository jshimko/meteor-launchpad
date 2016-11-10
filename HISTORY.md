
## v1.1.0

- update meteor build script to use `METEOR_ALLOW_SUPERUSER` in the build.  Discontinues support of Meteor 1.4.2.  Please update to Meteor 1.4.2.1 if you are currently on 1.4.2
- allow optional install of Graphicsmagick using launchpad.conf - Thanks @un1x86! (https://github.com/jshimko/meteor-launchpad/pull/20)
- update gosu to 1.10


## v1.0.0

- Add Docker build versioning to CI build.  Every tag in the form `vX.X.X` will now create and push a new build on CircleCI and update the `:latest` tag. You can now use `jshimko/meteor-launchpad:latest` to always use the latest, or you can pin a specific version with `jshimko/meteor-launchpad:v1.0.0`.  See all available builds here: https://hub.docker.com/r/jshimko/meteor-launchpad/tags/

This is also the last/only version of Meteor Launchpad to support Meteor 1.4.2.  The [issue with using Meteor commands as root](https://github.com/meteor/meteor/issues/7959) introduced in 1.4.2 caused a big problem for this image because it meant the build scripts would _only_ work for Meteor 1.4.2 or later (long story).  [This fix in 1.4.2.1](https://github.com/meteor/meteor/pull/7975/commits/e4acc36f63f98243237b5e6b3e46b083822b95fd) addresses that problem and now allows this image to support any version of Meteor >=1.3 (except 1.4.2 - which you should definitely upgrade if you are using it).
