#!/bin/bash

BASE_NAME='ncms-base'

IMAGE_NAME="centos:${BASE_NAME}"

# image build
docker build -t ${IMAGE_NAME} .

