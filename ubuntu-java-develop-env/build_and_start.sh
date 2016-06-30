#!/bin/bash

IMAGE_NAME='ubuntu:java-develop-env'

CONTAINER_NAME="ubuntu_java-develop-env"

# image build
docker build -t ${IMAGE_NAME} .

# container run
docker run -d --name ${CONTAINER_NAME} -i -p 5901:5901 -t ${IMAGE_NAME}

