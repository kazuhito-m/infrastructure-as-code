#!/bin/sh

# GKE上にクラスタを作成するためのスクリプト。
# あらかじめ、以下のことをしておくこと
# 
# sudo gcloud components update
# gcloud auth login

PROJECT_NAME=kfa-growi-on-gke
CLUSTER_NAME=kazuhito-sample

gcloud config set compute/zone asia-northeast1-a
gcloud config set project ${PROJECT_NAME}
gcloud container clusters create ${CLUSTER_NAME} --machine-type=n1-standard-1 --num-nodes=3                                         
gcloud container clusters get-credentials ${CLUSTER_NAME}

