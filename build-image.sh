#!/bin/bash

if [ -z "$1" ]; then
  echo "You must provide the path to the directory with the Dockerfile you want to build"
  echo "bash build-image.sh ./path/to/image"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "The path does not exist:"
  echo "$1"
  exit 1
fi

DOCKER_DIR=$1

# Build base docker image
docker build \
  --file $DOCKER_DIR/Dockerfile \
  --network=host \
  --pull \
  --tag $DOCKER_DIR \
  $DOCKER_DIR
