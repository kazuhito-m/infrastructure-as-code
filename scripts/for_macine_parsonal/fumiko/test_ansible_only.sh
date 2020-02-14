#!/bin/bash -x
# vagrantで仮想機立てて、プロビジョニングを実行するスクリプト

# 「このスクリプトがある場所」まで移動
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

# Ansbile実行
export ANSIBLE_HOST_KEY_CHECKING=False  # known_hosts の判定を回避

ansible-playbook \
    --timeout=180 \
    -i ./test_inventry main.yml \
    -u kazuhito \
    --private-key=/home/kazuhito/Dropbox/keys/github/id_rsa_github \
    --ask-become-pass \
    -vv