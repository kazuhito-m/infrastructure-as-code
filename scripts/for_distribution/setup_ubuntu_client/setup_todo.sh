#!/bin/bash

# 画面整え
# すべての設定->外観->Launcherアイコンのサイズ を 32 に
# すべての設定->ディスプレイ->拡大縮小 を 0.75 に

# Jenkinsの直指定インストール。
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
# これだけで入るので、あとは http://locahost:8080 で確認。
# 最初に二つのプラグインを入れる
# + Post build task
# + CloudBees Folders Plugin

# その後、Jobを固めたファイルを然るべきところに展開する。
sudo su jenkins
tar xzf ./resources/jenkins_jobs.tgz
mv /var/lib/jenkins/jobs /var/lib/jenkins/jobs.org
mv ./jobs /var/lib/jenkns/jobs
exit
# jenkins 再起動
sudo /etc/init.d/jenkins restart
# 音関係を鳴らす関係上、sudoノンパスでいけるようにしておく。
sudo visudo

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

# DTM関係よろずインストール
sudo apt-get install rosegarden hydrogen ardour
# ソフトシンセや「音源材料」系
sudo apt-get install qsynth fluid-soundfont-gm cmt calf-plugins caps tap-plugins invada-studio-plugins-lv2 swh-lv2 mda-lv2

# PlantUMLインストール
sudo apt-get install -y graphviz doxygen
# 依存関係の都合上、JDK6を入れないと、以下のDEBパッケージが入れられず…。(新しく環境を作るときは、ここを判断してください。汚すので。)
sudo apt-get install -y openjdk-6-jre
# 更に！依存関係がおかしくなったので、以下のコマンドで整えるはめに。(クリーンインストール時は、PlantUMLやめとこうかな？)
sudo apt-get -f install
# PlantUML自体は、Debパッケージでリソースからインストール
sudo dpkg -i ./resources/plantuml_7707-1_all.deb
# なんか文字化けまくるので、スクリプトに小細工
sudo vi /usr/bin/plantuml
# javaコマンド実行前に"export LANG=ja_JP.UTF-8"を入れる。
# しかもバグがあるみたいなので、最新のJarと置き換え
sudo cp ./resources/plantuml.jar /usr/share/plantuml/plantuml.jar

# ついでに「Atomのプラグイン」があるみたいだけど、コマンドライン案件ではないので、URL貼っとく。
# http://pierre3.hatenablog.com/entry/2015/08/23/220217
# もしかしたら…これでイケるかも？
apm install plantuml-viewer language-plantuml

# BootableUSBとか焼くために、UNetBootin入れとく。。
sudo apt-get install -y unetbootin

# ディスクのコントロールのため、GPartedは必須にしておく
sudo apt-get install -y gparted

# 画像変換の"mogrify"コマンドのため、以下を入れる。
sudo apt-get install -y imagemagick 

# Fablic入れる方法
sudo apt-get install python-setuptools
sudo easy_install pip 
sudo pip install fabric

# その他「ノンジャンルで雑多」なもの
sudo apt-get install -y stopwatch tree vim

# -- add ---
# special settings
jenkins ALL=(ALL) NOPASSWD:ALL
