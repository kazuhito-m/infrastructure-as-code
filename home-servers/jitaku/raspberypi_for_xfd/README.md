# raspaberypi_for_xfd

## What's this ?

RaspberyPiに(USB機器を電源管理出来る)USBハブと音声とJenkinsという「XFDの元」環境を作成する。

## Target

+ 対象OS(LinuxDistoribution) : Raspabian
+ 対象機器 : RaspaberyPi2

# 戦略・方針

過去の資産である

+ ../../chef_install - chefのubnutu/debianへのインストール
+ ../../usb-baspower-control_install - USBバスコントロールのスクリプト

の内容を含むものとなり、冗長だが「取り敢えずベタ書きで書く」ことにし、あとで整理する。

# スクリプトに現れない前提作業

0. SDカードにraspbian焼付け。

   ../../setup_sdcard_for_raspbian/setup_sdcard_for_latest_raspbian_only.sh を使い、SDカード焼付け。
   
0. インストール作業

  SDカードを突っ込んで初回だけディスプレイつなげてセットアップ。すぐにfinishで終了。
  
  ifconfig で「DHCPでフラれたipaddress」だけ調べ、それ以降は他端末からSSH。
  
0. chef-solo 系のセットアップ

   ../../chef_install/chef_install.sh の内容を叩く。
