#!/bin/sh

# GKE上にクラスタを作成するためのスクリプト。
# あらかじめ、以下のことをしておくこと
# 
# sudo gcloud components update
# gcloud auth login

PROJECT_NAME=kfa-growi-on-gke
CLUSTER_NAME=kazuhito-sample

REGION=asia-northeast1

NETWORK_NAME=gke-cluster-network
SUBNNET_NAME=gke-cluster-subnet 
RANGE=10.0.0.0/16

gcloud config set compute/zone ${REGION}-a
gcloud config set project ${PROJECT_NAME}

# Create VPC
gcloud compute networks create ${NETWORK_NAME} --subnet-mode custom
gcloud compute networks subnets create ${SUBNNET_NAME} \
    --network ${NETWORK_NAME} \
    --region ${REGION} \
    --range ${RANGE}
gcloud compute firewall-rules create ${NETWORK_NAME}-rule01 --network ${NETWORK_NAME} --allow tcp:80,icmp

# Create GKE Clusters
# gcloud container clusters create ${CLUSTER_NAME} \
#     --machine-type=n1-standard-1 \
#     --num-nodes=3 \
#     --enable-ip-alias \
#     --cluster-ipv4-cidr=/16 \
#     --services-ipv4-cidr=/22
# gcloud container clusters get-credentials ${CLUSTER_NAME}

