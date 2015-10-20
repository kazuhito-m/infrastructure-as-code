#!/bin/bash

USER_NAME=${1}

# ユーザ作成 & パスワード
sudo useradd -m ${USER_NAME}
echo "${USER_NAME}:test" | sudo chpasswd

# とあるファイルをコピー
sudo cp -r ~/.vnc /home/${USER_NAME}/
sudo chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.vnc
