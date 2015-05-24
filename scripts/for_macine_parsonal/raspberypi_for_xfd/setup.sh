#!/bin/bash

# シェルとして書いているが…そのままじゃ繋がらないはずなので、一行一行コピペ前提で。

# とりあえず、suじゃ。
sudo su -

# git で、このリポジトリを読み込む。
git clone https://github.com/kazuhito-m/dockers.git
cd ./dockers/scripts/for_macine_parsonal/raspberypi_for_xfd/chef-repo

# chef実行。
chef-solo -c ./solo.rb -j ./nodes/localhost.json
