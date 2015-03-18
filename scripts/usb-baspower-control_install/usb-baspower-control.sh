#!/bin/bash

#
# USBのバスパワーをOn/Offするシェルスクリプト。
#
# 特定のチップを積んだUSBハブ(lsusbで"Per-port power switching"となるもの)
# の場合のみポート別でUSBバスパワーをOn/Offするものです。
# 
# 外部プログラムのhub-ctrlというものをコマンドとして使います。
# 予め以下のコマンドでビルド/インストールを行ってください。
# 
# + RHEL/CentOS系
#
# (実行は全てrootとする)
# (RedHat系)
# yum install libusb-devel libusb-static gcc
# (Debian系)
# sudo apt-get install build-essential libusb-dev
# wget http://www.gniibe.org/oitoite/ac-power-control-by-USB-hub/hub-ctrl.c
# gcc -O2 hub-ctrl.c -o hub-ctrl -lusb
# chmod 755 ./hub-ctrl
# sudo cp ./hub-ctrl /usr/local/bin/
# sudo chmod u+s /usr/local/bin/hub-ctrl
# rm ./hub-ctrl* 
#
# ポート/デバイスについては、HubとUSB電源を使うガジェットをつないだ状態で、
# 一度 hub-ctrl をオプション無しで叩き、そこに表示されたものを
# 以下の定数にセットしてください。
#

export USB_HUBNUM=0
export USB_HUBPORT=1

export POWER_ON_INTERVAL=5

function switch_usb_buspower() {
  hub-ctrl -h ${USB_HUBNUM} -P ${USB_HUBPORT} -p ${1}
}

function poweron_by_interval() {
  switch_usb_buspower 1
  sleep ${POWER_ON_INTERVAL}
  switch_usb_buspower 0
}

# 数秒間USBバスパワーをONにする。(非同期で実行し終了を待たない。)
poweron_by_interval &
