#!/bin/bash

BASE_NAME='desktop_and_browsser_vnc'

IMAGE_NAME="centos:${BASE_NAME}"

CONTAINER_NO='6'
CONTAINER_NAME="${BASE_NAME}_${CONTAINER_NO}"

# image build
docker build -t ${IMAGE_NAME} .

# container run
# FIXME:vncポートだけは「コンテナ番号での付け替え」を行わず。そのままの番号で外だし。
#       （つまりは同一マシン内部に複数のVNCDockerが存在出来ないということ）
docker run -d --name ${CONTAINER_NAME} -i -p ${CONTAINER_NO}0022:22 -p ${CONTAINER_NO}4444:4444 -p 5901:5901 -t ${IMAGE_NAME}
