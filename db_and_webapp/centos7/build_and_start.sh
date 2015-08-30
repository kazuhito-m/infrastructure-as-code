#!/bin/bash

IMAGE_NAME='centos:db_and_webapp'

CONTAINER_NO='5'
CONTAINER_NAME="db_and_webapp_${CONTAINER_NO}"

# image build
docker build -t centos:db_and_webapp .

# container run
docker run -d --privileged --name ${CONTAINER_NAME} -i -p ${CONTAINER_NO}0022:22 -p ${CONTAINER_NO}8080:8080 -p ${CONTAINER_NO}3306:3306 -t ${IMAGE_NAME}

