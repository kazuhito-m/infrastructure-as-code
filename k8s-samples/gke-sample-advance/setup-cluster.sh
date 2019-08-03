#!/bin/sh

# GKE上にクラスタを作成するためのスクリプト。
# あらかじめ、以下のことをしておくこと
# 
# sudo gcloud components update
# gcloud auth login

PROJECT_NAME=kfa-growi-on-gke
CLUSTER_NAME=kazuhito-sample-01

REGION=asia-northeast1

NETWORK_NAME=gke-cluster-network
SUBNNET_NAME=gke-cluster-subnet 
RANGE=10.0.0.0/16

DB_INSTANCE_NAME=db-sample01
DB_CPU=1
DB_MEMORY=4GB
DB_STORAGE_SIZE=10GB
DB_STORAGE_TYPE=HDD #安いの

gcloud config set compute/zone ${REGION}-a
gcloud config set project ${PROJECT_NAME}

# Create VPC
gcloud compute networks create ${NETWORK_NAME} --subnet-mode custom
gcloud compute networks subnets create ${SUBNNET_NAME} \
    --network ${NETWORK_NAME} \
    --region ${REGION} \
    --range ${RANGE}
gcloud compute firewall-rules create ${NETWORK_NAME}-rule01 --network ${NETWORK_NAME} --allow tcp:80,icmp

# Create DB(CloudSQL)
gcloud sql instances create ${DB_INSTANCE_NAME} \
    --async \
    --availability-type=zonal \
    --database-version=POSTGRES_9_6 \
    --region=${REGION} \
    --cpu=${DB_CPU} \
    --memory=${DB_MEMORY} \
    --storage-size=${DB_STORAGE_SIZE} \
    --storage-type=${DB_STORAGE_TYPE}
# インスタンスの(GUIコンソールからの)設定
# - プライベートIPをOnにし、作成したVPN名を指定する
# - gke内にテスト用のPodを作り、DBに接続できるかテスト
# - パブリックIPをOffにする
# - 必要であればユーザを作成しておく

# Create GKE Clusters
gcloud container clusters create ${CLUSTER_NAME} \
    --network=${NETWORK_NAME} \
    --subnetwork=${SUBNNET_NAME} \
    --machine-type=n1-standard-1 \
    --num-nodes=3 \
    --enable-ip-alias \
    --cluster-ipv4-cidr=/16 \
    --services-ipv4-cidr=/22
gcloud container clusters get-credentials ${CLUSTER_NAME}

