#!/bin/bash

IMAGE_NAME='ubuntu:1404base'

CONTAINER_NO='5'
CONTAINER_NAME="ubuntu1610_${CONTAINER_NO}"

# image build
docker build -t ${IMAGE_NAME} .

# container run
docker run -d --name ${CONTAINER_NAME} -i -p ${CONTAINER_NO}0022:22 -p ${CONTAINER_NO}8080:8080 -p ${CONTAINER_NO}3306:3306 -t ${IMAGE_NAME}

