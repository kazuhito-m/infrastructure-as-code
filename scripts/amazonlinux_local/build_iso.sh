#!/bin/bash

# VertualBox用"local AmazonLinux Image"を作成するスクリプト。
# 必要なコマンド : curl,genisoimage

curl https://cdn.amazonlinux.com/os-images/2.0.20190313/virtualbox/amzn2-virtualbox-2.0.20190313-x86_64.xfs.gpt.vdi > amzn2-virtualbox.vdi

genisoimage -output seed.iso -volid cidata -joliet -rock user-data meta-data

# そのあとは「以下の手順」でVirtualBoxから起動する。
# https://qiita.com/aibax/items/88e2ab6794cfc89ff997

# その後、以下でログイン。
# ssh -i ./id_rsa ec2-user@192.168.1.180
