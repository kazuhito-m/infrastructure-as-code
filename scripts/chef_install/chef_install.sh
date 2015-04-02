#!/bin/bash

# 簡易な「サーバにChefを入れるまで」というスクリプトをまとめる。
# (Chef以降はChef側にまかせる)
#
# ※極力楽するので、本当は良くないがyumに依存したり、いろいろ筋の悪いことをしているのは承知の上。
#
# 対象:CentOS7
# user:root
# 作業dir:任意
#

# TODO 必要とあらばここに環境の前準備(Proxyとか)

# Ruby最新インストール(リポジトリ任せ)
# これでは何故か取れない。他のリポジトリを足すソースを追加する。:
yum install -y ruby ruby-devel chef git

# Ubuntu/Debian
#
# sudo apt-get update -y
# sudo apt-get upgrade -y
# sudo apt-get install -y ruby git curl

# Chefインストール(ユーザはroot前提。一般ユーザならsudo付けて)
# * 方針を変え、すべてパッケージで入れることに
# curl http://www.opscode.com/chef/install.sh | bash

# レポジトリの作成。
# git clone http://github.com/opscode/chef-repo.git

# クックブックの作成。
# knife configure
