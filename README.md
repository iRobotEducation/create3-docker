# create3-docker

Dockerfiles for running ROS 2 applications for the iRobot Create 3 educational robot.

## How to run Docker containers

The Docker images built through this repository are available from the DockerHub.
The following is an example command used to run it.

```bash
docker run -it --rm --network=host --privileged -e DISPLAY=$DISPLAY irobotedu/create3-humble
```

### Build a Docker image locally

```bash
./build-image.sh IMAGE_DIR
```

You can pass additional arguments to the script, for example to indicate the target platform

```bash
./build-image.sh create3-humble --platform=linux/arm64
```

## Developers Instructions

Each Docker image should be placed, together with all the additional files it requires, in a directory named as the image itself.

### Deploying image to Docker Hub

Use this command to build the current images and deploy them to the DockerHub.
This command requires the iRobotEDU DockerHub login details.

```bash
docker login
./deploy.sh create3-humble --platform=linux/arm64,linux/amd64 --latest --version 0.0.2
```
