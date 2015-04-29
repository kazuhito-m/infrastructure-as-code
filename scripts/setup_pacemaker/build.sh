#!/bin/bash

BASE_NAME='pm01'

IMAGE_NAME="centos:${BASE_NAME}"

# image build
docker build -t ${IMAGE_NAME} .

