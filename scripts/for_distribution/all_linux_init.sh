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
sudo apt-get install ubuntu-restricted-extras

# クロームがいいかなー
sudo apt-get install chromium-browser


