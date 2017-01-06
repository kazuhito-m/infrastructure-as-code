#!/bin/bash

docker-compose up -d

# composeが使えない場合
# docker build -t postgres:original01 .
# docker run -d -p 5432:5432 --name postgres-base postgres:original01
