#!/bin/bash

echo "execute date:`date`"

# Jenkinsのワークフォルダ削除
rm -rf /var/local/jenkins/workspace

# Docker内の「使っていないイメージ」を削除(恐らくないが)
docker images -a | xargs docker rmi

# Swapfileを作成＆有効化(swapon)
SWAP_FILE=/ephemeral/swapfile
rm -f ${SWAP_FILE}
dd if=/dev/zero of=${SWAP_FILE} bs=1024K count=3700
mkswap ${SWAP_FILE}
swapon ${SWAP_FILE}
