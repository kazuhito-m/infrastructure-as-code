#!/bin/bash

# OpenJtalkと、HTS-Engine、またボイスのデータをCentOSにインストールするシェルスクリプト。
# 以下のコマンドに依存します。予めyum等でインストールしておいてください。
# また、sudoをたたくこととなるため、sudoに権限が与えられてるユーザで実行してください。
#   gzip,tar,gcc,make,sudo 

# hts_engine のインストール
tar xvzf hts_engine_API-*.tar.gz
cd hts_engine_API-*
./configure
make
sudo make install
cd ../

# open-jtalk install
tar xvzf open_jtalk-*
cd open_jtalk-*
./configure --with-charset=UTF-8
make
sudo make install
cd ../

# voice data install
tar xvzf ./voice.tgz
chmod 755 ./voice
sudo mv ./voice /usr/local/voice

# script install
chmod 755 ./talktext
sudo cp ./talktext /usr/local/bin/talktext
