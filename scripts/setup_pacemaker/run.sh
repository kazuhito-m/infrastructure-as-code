#!/bin/bash

# ホスト名指定、イメージ指定、ネーム指定で、起動。
hostname='pm01'
docker run -v ${PWD}/chef-repo:/chef-repo -d --name ${hostname} -h ${hostname} -t centos:${hostname} 
