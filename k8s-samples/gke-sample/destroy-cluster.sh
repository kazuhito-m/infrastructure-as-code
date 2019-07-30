#!/bin/sh

# GKE上にクラスタを作成するためのスクリプト。
# あらかじめ、以下のことをしておくこと
# 
# sudo gcloud components update
# gcloud auth login

PROJECT_NAME=kfa-growi-on-gke
CLUSTER_NAME=kazuhito-sample

gcloud container clusters delete ${CLUSTER_NAME}

echo "削除完了しました。GCPのComputeEngineから、「クラスタに使われていたVMのディスク」を削除してください。"
