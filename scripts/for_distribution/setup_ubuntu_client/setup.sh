#!/bin/bash 

# Directory name rename
LANG=C xdg-user-dirs-gtk-update

# git settings
git config --global user.email "sumpic@hotmail.com"
git config --global user.name "kazuhito-m"

cat << _EOT_ > ~/.netrc
machine github.com
login kazuhito-m
password xxxxxxxx
_EOT_

# コーデックなど一式をグループインストール
sudo apt-get install -y ubuntu-restricted-extras

# クロームがいいかなー
# 参考:http://tecadmin.net/install-google-chrome-in-ubuntu/
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update -y

# ドローイングソフト系
sudo apt-get install -y gimp

# Jenkinsの直指定インストール。
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
# これだけで入るので、あとは http://locahost:8080 で確認。
# 最初に二つのプラグインを入れる
# + Hudson Post build task
# + CloudBees Folders Plugin

# その後、Jobを固めたファイルを然るべきところに展開する。
