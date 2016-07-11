[![Circle CI](https://circleci.com/gh/jshimko/meteor-launchpad/tree/master.svg?style=svg)](https://circleci.com/gh/jshimko/meteor-launchpad/tree/master)
## Meteor Launchpad - Base Docker Image for Meteor Apps

### Build

Add the following to a `Dockerfile` in the root of your app:

```Dockerfile
FROM jshimko/meteor-launchpad:latest
```

Then you can build the image with:

```sh
docker build -t yourname/app .
```

### Run

Now you can run your container with...

```sh
docker run -d \
  -e ROOT_URL=http://example.com \
  -e MONGO_URL=mongodb://url \
  -e MONGO_OPLOG_URL=mongodb://oplog_url \
  -e MAIL_URL=smtp://mail_url.com \
  -p 80:80 \
  yourname/app
```

### Development Builds

You can optionally avoid downloading Meteor every time when building regularly in development.  Add the following to your Dockerfile instead...

```Dockerfile
FROM jshimko/meteor-launchpad:devbuild
```

This isn't recommended for your final production build because it creates a much larger image, but it's a bit of a time saver when you're building often in development.  The first build you run will download/install Meteor and then every subsequent build will be able to skip that step and just build the app.

### Docker Compose

```yaml
# docker-compose.yml

app:
  image: yourname/app
  ports:
    - "80:80"
  links:
    - mongo
  environment:
    - ROOT_URL=http://example.com
    - MONGO_URL=mongodb://mongo_url:27017/meteor
    - MONGO_OPLOG_URL=mongodb://oplog_url:27017/meteor
    - MAIL_URL=smtp://mail_url.com

mongo:
  image: mongo:latest --storageEngine=wiredTiger
```

And then start the containers with...

```sh
docker-compose up -d
```
