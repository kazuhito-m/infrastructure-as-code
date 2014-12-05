#!/bin/bash

BASE_NAME='funiki_bot_kit'

IMAGE_NAME="ubuntu:${BASE_NAME}"

CONTAINER_NO='3'
CONTAINER_NAME="${BASE_NAME}_${CONTAINER_NO}"

# image build
docker build -t ${IMAGE_NAME} .

# container run
docker run -d --name ${CONTAINER_NAME} -i -p ${CONTAINER_NO}0022:22 ${CONTAINER_NO}6379:6379 -t ${IMAGE_NAME}
