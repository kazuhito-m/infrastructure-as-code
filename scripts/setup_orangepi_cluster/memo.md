# orangepi の設定メモ

## 一台目の設定から取れる手順

- OrangePIの型番
  - Orange PI PC rev.1.2
- OS選び
  - armbianは動かず
    - OrangePIPC用の最新を使ったが動かず
  - 本家のOrangePI用Raspabian
    - 2016年とちょっと古い
- IP調べ
  - 画面、SSHはデフォルトで上がり、かつDHCPでIP取るようなので、外部ログインできるようにipを探す
  - が、自身の持ってるディスプレイではずれて使い物にならない
  - root/oranepiで画面ログインし、マウス・キーボードを駆使してなんとか「ifconfig eth0」を叩く
- デスクトップ起動をやめる
  - 外側からSSHで入る
  - `raspi-config` で「起動時に起動しない」設定に
- byobuインストール
  - `apt-get install byobu`
- デスクトップ系の削除
  - `apt-get install deborphan`
  - `apt-get remove libcairo2 libgdk-pixbuf2.0-0 libpango1.0-0 libpulse0 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxft2 libxft2 libxinerama1 libxrandr2 libxrender1 libxtst6 libxxf86vm1 openjdk-7-jre`
  - `apt-get autoremove --purge libx11-.* lxde-.* raspberrypi-artwork xkb-data omxplayer penguinspuzzle sgml-base xml-core alsa-.* cifs-.* samba-.* fonts-.* desktop-* gnome-.*`
  - `apt-get remove --purge $(deborphan)`
  - `apt-get autoremove`
- Packageアップグレード
  - `apt-get update && apt-get dist-upgrade`
  - `apt-get autoremove`
