#!/bin/bash -x

# システムテスト自動化ワークショップ用、Ubunutのセットアップ用スクリプト。

# Javaセットアップ
sudo apt-get install openjdk-8-jdk curl -y

# IntalliJ IDEA インストール
rm -f ./ideaIC*.tar.gz
wget http://download.jetbrains.com/idea/ideaIC-14.0.3.tar.gz
gunzip ./ideaIC*.tar.gz
tar xf ./ideaIC*.tar
rm ./ideaIC*.tar
rm -rf /opt/idea/
sudo mv ./idea-IC* /opt/idea
echo 'export PATH=/opt/idea/bin:$PATH' >> ~/.bashrc

# GVM インストール(ユーザ個人用)
curl -s get.gvmtool.net | bash
source ~/.gvm/bin/gvm-init.sh

# groovy インストール
gvm i groovy
groovy -v #確認

# gradle インストール
gvm i gradle
gradle -v #確認

# Heroku Toolbelt インストール
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
