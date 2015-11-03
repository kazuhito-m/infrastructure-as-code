#!/bin/bash

# 画面整え
# すべての設定->外観->Launcherアイコンのサイズ を 32 に
# すべての設定->ディスプレイ->拡大縮小 を 0.75 に

# docker インストール
sudo apt-get install docker

# scala develop environment
SCALA_VER='2.12.0-M2'
SBT_VER='0.13.9'
wget www.scala-lang.org/files/archive/scala-${SCALA_VER}.deb
wget https://dl.bintray.com/sbt/debian/sbt-${SBT_VER}.deb
sudo apt-get update
sudo dpkg -i scala-${SCALA_VER}.deb sbt-${SBT_VER}.deb
# conscript , giter8 (この技術は廃れるかもしれない。試験導入。)
wget https://raw.github.com/n8han/conscript/master/setup.sh
chmod 755 ./setup.sh
./setup.sh
rm ./setup.sh
^/bin/cs n8han/giter8


# -- add ---
# special settings
jenkins ALL=(ALL) NOPASSWD:ALL
