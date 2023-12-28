#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Extract first positional argument
DOCKER_DIR=$1
shift

if [ -z "${DOCKER_DIR}" ]; then
  echo "You must provide the path to the directory with the Dockerfile you want to build and deploy."
  echo "bash deploy.sh ./path/to/directory"
  exit 1
fi
if [ ! -d "${DOCKER_DIR}" ]; then
  echo "The path does not exist: ${DOCKER_DIR}".
  echo "You must provide the path to the directory with the Dockerfile you want to build build and deploy."
  echo "bash deploy.sh ./path/to/directory"
  exit 1
fi
DOCKERFILE=${DOCKER_DIR}/Dockerfile
if [ ! -f ${DOCKERFILE} ]; then
  echo "The Dockerfile does not exist: ${DOCKERFILE}."
  echo "You must provide the path to the directory with the Dockerfile you want to build build and deploy."
  echo "bash deploy.sh ./path/to/directory"
  exit 1
fi

# Variables default values
DOCKERHUB_USER="irobotedu"
VERSION=""
TAG_AS_LATEST=""
ADDITIONAL_ARGS=()

# Parse input arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --user)
      DOCKERHUB_USER="$2"
      shift # past argument
      shift # past value
      ;;
    --version)
      VERSION=":$2"
      shift # past argument
      shift # past value
      ;;
    --latest)
      TAG_AS_LATEST="Yes"
      shift # past argument
      ;;
    *)
      ADDITIONAL_ARGS+=("$1") # save additional arguments
      shift # past argument
      ;;
  esac
done

# Create docker tags
IMAGE_NAME=${DOCKER_DIR}
VERSIONED_TAG="${DOCKERHUB_USER}/${IMAGE_NAME}${VERSION}"

# Print the deploy configuration
echo "Deploy configuration:"
echo "    - Docker directory '${DOCKER_DIR}'"
echo "    - Image name '${IMAGE_NAME}'"
echo "    - Versioned tag '${VERSIONED_TAG}'"
echo "    - Tag as latest? ${TAG_AS_LATEST:-No}"
echo "    - Arguments '${ADDITIONAL_ARGS}'"

read -r -p "Would you like to start the deployment? [Y/n] " input
if [[ ! "${input}" ]]; then
  input=y
fi
case ${input} in
  [yY][eE][sS]|[yY])
echo "Starting deploy! This could take a while."
;;
  *)
echo "Deploy cancelled."
exit 1
;;
esac

LATEST_TAG=""
LATEST_TAG_ARG=""
if [ -n "${TAG_AS_LATEST}" ]; then
  LATEST_TAG="${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
  LATEST_TAG_ARG="--tag ${LATEST_TAG}"
  echo "Tagging ${VERSIONED_TAG} as latest"
fi

VERSIONED_TAG_ARG="--tag ${VERSIONED_TAG}"

${THIS_DIR}/build-image.sh ${DOCKER_DIR} \
  ${ADDITIONAL_ARGS} \
  --push \
  ${VERSIONED_TAG_ARG} \
  ${LATEST_TAG_ARG}

