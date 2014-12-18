#!/bin/bash

BASE_NAME='webapp-glassfish'
IMAGE_NAME="centos:${BASE_NAME}"

CONTAINER_NO='3'
CONTAINER_NAME="${BASE_NAME}_${CONTAINER_NO}"

# image build
docker build -t ${IMAGE_NAME} .

# container run
docker run -d --name ${CONTAINER_NAME} -i -p ${CONTAINER_NO}0022:22 -p ${CONTAINER_NO}8080:8080 -t ${IMAGE_NAME}
