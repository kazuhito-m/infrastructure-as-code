セットアップ手動作業
===

全てをAsCode出来ないので、手動の手順を記す。

2022/07/20 `apt-get dist-upgrade` したら再起動不能になったので、再度インストール。

(以前のこのマシンが「何の責務だったのか」は残ってない。)

# Raspabinインストール＆付属設定

1. https://www.raspberrypi.org/downloads/ から、 rpi-imagerのdebパッケージを取得
0. 上記をUbuntuにインストール
0. rpi-managerを実行、SDカードにraspabianを焼く
0. SDカードを指して、RaspberryPI起動
0. 最新のRaspaberryOSでは「ユーザを最初に指定する」のでkazuhitoを追加
0. ip固定 https://qiita.com/momotaro98/items/fa94c0ed6e9e727fe15e
0. 再起動
0. ので、systemctl enable ssh && reboot
0. ./run.sh
0. reboot
