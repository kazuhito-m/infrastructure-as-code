#!/bin/bash

# RaspabianのみをSDカードにコピーするスクリプト。
# こちらを参考にダウンロード、SDカード焼付けを行う手順となっている。
#   http://www.mztn.org/rpi/rpi39.html

# OSイメージ系固定値
download_url=http://downloads.raspberrypi.org/raspbian_latest

# 自分マシンのSDのデバイス名(間違えると詰むので要確認！)
sddev=/dev/mmcblk0

# ダウンロード後のファイル名
imagefile=raspbian.zip

# ※必要な場合蘇らせる
sudo dd if=/dev/zero of=${sddev}

# 初回手順では以下の通り行ったが…パーティションごと上書かられるので、いらないかも。

# SDカードをパーティション設定＆フォーマット
# sudo fdisk ${sddev} # vfat、1パーティションで切る。
# sudo mkfs.vfat ${sddev}p1


#ファイルをダウンロードして展開
wget ${download_url} -O ${imagefile}
unzip ${imagefile}
imgfile=`ls *raspbian*.img`

# SDカードに書き込む(かなり時間が掛かる)
dd if=${imgfile} of=${sddev}
