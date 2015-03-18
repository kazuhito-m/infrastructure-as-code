# tipmsgをインストールするスクリプト。
# 
# コンソールからIPMessengerをたたくことができる、
# tipmsg をインストールするシェルスクリプト。
# 
# build-essential がインストールされていることを期待している。

#!/bin/bash

mkdir work
cd ./work

# ダウンロード
wget http://www.kouno.jp/home/soft_lab/tipmsg/tipmsg04.tar.gz
tar xvzf tipmsg*.tar.gz
cd tipmsg*

# コンパイル
make

# インストール(副作用が少ないように /usr/local/binにコピーするだけ)
sudo cp ./tipmsg /usr/local/bin/

# 後始末。
cd ../../
rm -rf ./work

# ここからは個人設定。
# このmakeしたユーザで使い続けるなら、以下を実行。
mkdir ~/tipmsg
cat << _EOT_ > ~/tipmsg/tipmsg.conf
NAME=ユーザ
GROUP=グループ
# HOSTNAME = マシンの名前
SYSTEM DIR=~/tipmsg/
_EOT_

# 代表的な使い方を示します。
#
# tipmsg -D
# echo "test" | tipmsg -s hostname
# timpsg -t
#