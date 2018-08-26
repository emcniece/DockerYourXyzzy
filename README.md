# Docker Your Xyzzy

Get your Xyzzy on: `docker pull emcniece/dockeryourxyzzy`

- [Github](https://github.com/emcniece/DockerYourXyzzy)
- [Docker Hub](https://github.com/emcniece/DockerYourXyzzy)

# Supported tags and respective `Dockerfile` links:

- `latest`, `run`, `1`, `1-run` ([Dockerfile](./Dockerfile))
- `base`, `1-base` ([Dockerfile](./Dockerfile))
- `dev`, `1-dev` ([Dockerfile](./Dockerfile))

# What is Docker Your Xyzzy?

This is a containerized build of the [Pretend You're Xyzzy](https://github.com/ajanata/PretendYoureXyzzy) Cards Against Humanity clone.

This multi-step [Dockerfile](./Dockerfile) contains 3 stages: `base`, `dev`, and `run`. The `base` image will copy the compiled files over to an output directory, and the `dev` and `run` images will run the project.


# Usage

The PYX project can be used in Docker format for development, outputting the built files, or running in production.

## Output Built Files to Directory

Copy the `.war` and `.jar` files to `./xyz-output/`:

```sh
docker run --rm \
  -v $(PWD)/xyz-output:/output \
  emcniece/dockeryourxyzzy:base

ls -al ./output
```

## Run In Development Mode

Keep the container up with SQLite and `war:exploded jetty:run`:

```sh
docker run -d \
  -p 8080:8080 \
  --name pyx-dev \
  emcniece/dockeryourxyzzy:dev

# Visit http://localhost:8080 in your browser
# Or, start a bash session within the container:
docker exec -it pyx-dev bash
```


## Build With Overrides

Settings in `build.properties` can be modified by passing them in the container CMD:

```sh
docker run -d \
  -p 8080:8080 \
  emcniece/dockeryourxyzzy:dev \
  mvn clean package war:war \
    -Dhttps.protocols=TLSv1.2 \
    -Dmaven.buildNumber.doCheck=false \
    -Dmaven.buildNumber.doUpdate=false \
    -Dmaven.hibernate.url=jdbc:postgresql://postgres/pyx
```


## Run In Production Mode

Project `build.properties` commands can be overridden by altering the default container CMD:

```sh
docker run -d \
  -p 8080:8080 \
  emcniece/dockeryourxyzzy:run
```

# Building

This project can be built and run by any of the 3 following methods: CLI `docker build` commands, CLI `make` commands, or Docker-Compose.

## Makefile

The [Makefile](./Makefile) documents the frequently used build commands:

```sh
# Build default (full / runtime) image
make image

# Build base image
make image-base

# Build dev image
make image-dev

# Build runtime image
make image-run

# Run container
make run

# Run in debug mode (no container CMD):
make run-debug
```


## Docker Build

Docker commands can be found in the [Makefile](./Makefile):

```sh
# Build full/runtime image
docker build -t pyx

# Build dev image
docker build -t pyx --target dev
```

## Docker-Compose

An example production stack of PYX with a Postgres container can be found in [docker-compose.yml](./docker-compose.yml):

```sh
# Run PYX/Postgres stack
docker-compose up -d
```

# ToDo

- [ ] Figure out how to run `:latest` properly
- [ ] Buildtime config customization via Maven flags
- [ ] Runtime config customization via Maven flags
- [ ] Fetch GeoIP database in entrypoint.sh

# Notes

- Versioning and tagging isn't done well here because [Pretend You're Xyzzy](https://github.com/ajanata/PretendYoureXyzzy) doesn't seem to tag or version.