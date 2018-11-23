#!/bin/bash -x

# 設定インポート
. /config.sh

# 固定IPでのウェブアクセスを行うためのSocks Proxyを立ち上げる。
ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_FILE} -N -D ${SSH_PROXY_PORT} ${SSH_USER}@${SSH_HOST} -p ${SSH_PORT} &

# 元DockerイメージのENTRYPOINTを実行。
/startup.sh
