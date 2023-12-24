# create3-docker

Dockerfiles for running ROS 2 applications for the iRobot Create 3 educational robot.

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

 - Login to Docker Hub
 - Build image locally
 - Tag the image
 - Push tag

 Full example:

```bash
docker login
./build-image.sh create3-galactic
docker tag create3-galactic irobotedu/create3-galactic:0.0.1
docker push irobotedu/create3-galactic:0.0.1
docker tag create3-galactic irobotedu/create3-galactic:latest
docker push irobotedu/create3-galactic:latest
```
