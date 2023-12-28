#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

DOCKER_DIR=$1
if [ -z "${DOCKER_DIR}" ]; then
  echo "You must provide the path to the directory with the Dockerfile you want to build".
  echo "bash build-image.sh ./path/to/image"
  exit 1
fi
if [ ! -d "${DOCKER_DIR}" ]; then
  echo "The path does not exist: ${DOCKER_DIR}."
  echo "You must provide the path to the directory with the Dockerfile you want to build".
  echo "bash build-image.sh ./path/to/image"
  exit 1
fi
DOCKERFILE=${DOCKER_DIR}/Dockerfile
if [ ! -f ${DOCKERFILE} ]; then
  echo "The Dockerfile does not exist: ${DOCKERFILE}."
  echo "You must provide the path to the directory with the Dockerfile you want to build".
  echo "bash build-image.sh ./path/to/image"
  exit 1
fi

# All arguments after the first one are directly passed to the build command
ADDITIONAL_ARGS=${@:2}

# Check the existance of the Docker builder
DOCKER_BUILDER_NAME="create3-docker"
DOCKER_BUILDER_EXISTS=$( docker buildx ls | grep ${DOCKER_BUILDER_NAME} || true; )
if [ -z "${DOCKER_BUILDER_EXISTS}" ]; then
    echo "The docker builder ${DOCKER_BUILDER_NAME} doesn't exist. Creating it."
    docker buildx create --name ${DOCKER_BUILDER_NAME}
    echo "DONE"
fi
BUILDER_CMD="--builder ${DOCKER_BUILDER_NAME}"

# Build docker image
CMD=(docker build \
  ${BUILDER_CMD} \
  --file ${DOCKERFILE} \
  ${ADDITIONAL_ARGS} \
  ${DOCKER_DIR})

# Print the command we are about to execute
echo "####
${CMD[@]}
####"
# Run the command to build the docker image
"${CMD[@]}"
