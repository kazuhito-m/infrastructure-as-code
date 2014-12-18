#!/bin/bash

BASE_NAME='xmpp-chatserver'

IMAGE_NAME="centos:${BASE_NAME}"
CONTAINER_NAME="${BASE_NAME}"

# image build
docker build -t ${IMAGE_NAME} .

# container run
# 注:vncポートだけは「コンテナの番号での付替え」を行わず、そのまま外出し。(つまり、同一マシン内に複数存在できないということ)
docker run -d --name ${CONTAINER_NAME} -i -p 11122:22 -p 13306:3306 -p 5222:5222 -p 5223:5223 -p 5269:5269 -p 9090:9090 -p 7777:7777 -p 7070:7070 -p 7443:7443 -p 5229:5229 -t ${IMAGE_NAME}

