# create3-docker

Dockerfile for Running Create3 applications

Each Docker image should be placed, together with all the additional files it requires, in a directory named as the image itself.

### Build a Docker image locally


```bash
./build-image.sh IMAGE_DIR
```

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
```
