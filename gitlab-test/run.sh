#!/bin/bash

# gitlabを試験的にDocker内で立ち上げるスクリプト
# 
# ３つのDockerコンテナを使い、GitLabを立ち上げる。
#
# 配布元: https://github.com/sameersbn/docker-gitlab#introduction 
# 
# 前提
#   作業はすべてrootで行う事。
#   インターネットにつながっており、docker pullが動くこと。
#   dockerコマンドが使えること。

# 定数系

SERVER_IP='192.168.1.92'
GITLAB_HOST_DATA_MOUNT='/var/gitlab'

# 実処理

# gitlab用のMySQLの入れ物をhostmachine側に作成。
mkdir -p ${GITLAB_HOST_DATA_MOUNT}/{mysql,git}
chmod 777 -R ${GITLAB_HOST_DATA_MOUNT}
chcon -Rt svirt_sandbox_file_t ${GITLAB_HOST_DATA_MOUNT}/mysql

# redis のサーバ立ち上げ
docker run --name gitlab-redis -d sameersbn/redis:latest

# gitlab用のMySQLサーバ立ち上げ
docker run --name=gitlab-mysql -d \
  --env='DB_NAME=gitlabhq_production' \
  --env='DB_USER=gitlab' --env='DB_PASS=password' \
  --volume=${GITLAB_HOST_DATA_MOUNT}/mysql:/var/lib/mysql \
  sameersbn/mysql:latest

# 直前に阿智あげたradis/mysqlサーバにて「内部サービスが立ち上がる」まで、待つ。
interval=30
echo "wait docker wakeup $interval seh..."
sleep $interval

# 本丸、gitlabを立ち上げる
docker run -d --name gitlab \
  -p 10080:80 \
  -e 'GITLAB_PORT=10080' \
  -e "GITLAB_HOST=${SERVER_IP}" \
  --link gitlab-mysql:mysql \
  --link gitlab-redis:redisio \
  sameersbn/gitlab:latest

# 本来は、上記のコマンドに
# --volume=/var/gitlab/git:/home/git/data \
# というオプションがあったのだが、
# "docker log gitlab" した結果、
# 「mkdir で permission error 吐きまくる」
# とわかったため、除いている。

echo 'finished docker run for gitlab server wake up!'
echo "please click http://${SERVER_IP}:10080/ after 5 - 10 min."

