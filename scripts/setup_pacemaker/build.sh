#!/bin/bash

<<<<<<< HEAD
BASE_NAME='pm01'
=======
BASE_NAME='peacemaker'
>>>>>>> c7c55bfc886abdab3c0588acc4a3cb7c48f4b5c7

IMAGE_NAME="centos:${BASE_NAME}"

# image build
docker build -t ${IMAGE_NAME} .

