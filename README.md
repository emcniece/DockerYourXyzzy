# Docker Your Xyzzy

![docker publish](https://github.com/emcniece/DockerYourXyzzy/workflows/Publish%20Docker/badge.svg)

Get your Xyzzy on: `docker pull emcniece/dockeryourxyzzy`

- Github: [emcniece/DockerYourXyzzy](https://github.com/emcniece/DockerYourXyzzy)
- Docker Hub: [emcniece/dockeryourxyzzy](https://hub.docker.com/r/emcniece/dockeryourxyzzy/)


# Supported tags and respective `Dockerfile` links:

- `latest`, `4` ([Dockerfile](./Dockerfile))


# What is Docker Your Xyzzy?

This is a containerized build of the [Pretend You're Xyzzy](https://github.com/ajanata/PretendYoureXyzzy) Cards Against Humanity clone.

> ⚠ Version 3 (April 2020) is a vastly simplified Docker image, may break if upgrading from version 2. It no longer features multi-step builds.


# Usage

The PYX project can be used in Docker format for development, outputting the built files, or running in production.


## Run with Docker-Compose (fastest)

An example stack of PYX with a Postgres database and an [Ngrok](https://ngrok.com/) tunnel can be found in [docker-compose.yml](./docker-compose.yml):

```sh
# Run PYX/Postgres stack
docker-compose up -d --build
```

Once the containers are running, you can:

- Visit http://localhost:8080/game.jsp to play locally
- Visit http://localhost:4040/status to find your Ngrok URL
- Visit https://#####.ngrok.io to share publicly

## Run Standalone Container

Keep the container up with SQLite and `war:exploded jetty:run`:

```sh
docker run -d \
  -p 8080:8080 \
  --name pyx-dev \
  emcniece/dockeryourxyzzy:latest

# Visit http://localhost:8080 in your browser
# Or, start a bash session within the container:
docker exec -it pyx-dev bash
```


## Run With Overrides

Settings in `build.properties` can be modified by passing them in the container CMD:

```sh
docker run -d \
  -p 8080:8080 \
  emcniece/dockeryourxyzzy:latest \
  mvn clean package war:war \
    -Dhttps.protocols=TLSv1.2 \
    -Dmaven.buildNumber.doCheck=false \
    -Dmaven.buildNumber.doUpdate=false \
    -Dmaven.hibernate.url=jdbc:postgresql://postgres/pyx
```


# Building

This project can be built and run by any of the 3 following methods: CLI `docker build` commands, CLI `make` commands, or Docker-Compose.


## Build via `make`

The [Makefile](./Makefile) documents the frequently used build commands:

```sh
# Build default (full / runtime) image
make image

# Run container
make run

# Run in debug mode (no container CMD):
make run-debug
```


## Build via `docker build`

Docker commands can be found in the [Makefile](./Makefile):

```sh
# Build full/runtime image
docker build -t pyx
```


## Build via Docker-Compose

Force building with the `--build` flag:

```sh
# Run PYX/Postgres stack
docker-compose up -d --build
```


# ToDo

- [x] Figure out how to run `:latest` properly with a Postgres db
- [ ] Import & run sql files if specified for the Postgres db
- [ ] Buildtime config customization via Maven flags
- [ ] Runtime config customization via Maven flags
- [ ] Fetch GeoIP database in entrypoint.sh


# Notes

- ~Haven't actually got this working with an external Postgres db yet~
  - Now available via `docker-compose`
- Versioning and tagging isn't done well here because [Pretend You're Xyzzy](https://github.com/ajanata/PretendYoureXyzzy) doesn't seem to tag or version.
