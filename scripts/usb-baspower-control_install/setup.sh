#!/bin/bash

#
# USBのバスパワーをOn/Offするコマンドをインストールするスクリプト。
#
# 特定のチップを積んだUSBハブ(lsusbで"Per-port power switching"となるもの)
# の場合のみポート別でUSBバスパワーをコントロールするコマンドをインストーするものです。
 
# + RHEL/CentOS系
# (実行は全てrootとする)
# (RedHat系)
yum install libusb-devel libusb-static gcc
# (Debian系)
sudo apt-get install build-essential libusb-dev

# ここからはビルド。
# wget http://www.gniibe.org/oitoite/ac-power-control-by-USB-hub/hub-ctrl.c
gcc -O2 ./hub-ctrl.c -o hub-ctrl -lusb
chmod 755 ./hub-ctrl
sudo cp ./hub-ctrl /usr/local/bin/
sudo chmod u+s /usr/local/bin/hub-ctrl
rm ./hub-ctrl* 
