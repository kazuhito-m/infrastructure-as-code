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

DB_INSTANCE_NAME=db-sample01

gcloud container clusters delete ${CLUSTER_NAME}

echo "削除完了しました。GCPのComputeEngineから、「クラスタに使われていたVMのディスク」を削除してください。"

gcloud sql instances delete ${DB_INSTANCE_NAME}

gcloud compute firewall-rules delete ${NETWORK_NAME}-rule01
gcloud compute networks subnets delete ${SUBNNET_NAME} --region ${REGION}
# コンソールから「ルート」「VPCピアリングネットワーク」「プライベートサービス接続」で属しているものをすべて削除してからでしか、以下を実行できない
# gcloud compute networks delete ${NETWORK_NAME}
