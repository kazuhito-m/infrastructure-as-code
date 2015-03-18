#!/bin/bash

# OSイメージ系固定値
download_url=http://director.downloads.raspberrypi.org/NOOBS_lite/images/NOOBS_lite-2014-07-08/NOOBS_lite_v1_3_9.zip
imagefile=NOOBS_lite.zip

# 自分マシンのSDのデバイス名(間違えると詰むので要確認！)
sddev=/dev/sdb

# sudo dd if=/dev/zero of=${sddev}

# SDカードをパーティション設定＆フォーマット
sudo fdisk ${sddev}
sudo mkfs.vfat ${sddev}

#ファイルをダウンロードして展開
wget ${download_url}
mv NOOBS_lite*.zip ${imagefile}
mkdir -p ./img
sudo mount /dev/sdb1 ./img/
sudo cp ${imagefile} ./img/
cd ./img/
sudo unzip ./${imagefile}
sudo rm ./{$imagefile}
cd ..

# 後始末
sudo umount ./img
rm ${imagefile}
