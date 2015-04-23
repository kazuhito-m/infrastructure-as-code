#!/bin/bash

BASE_NAME='peacemaker'

IMAGE_NAME="centos:${BASE_NAME}"

# image build
docker build -t ${IMAGE_NAME} .

