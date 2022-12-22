# 外部環境の設定

KURO-NAS/X4 の設定には、外部環境にtftpサーバなど「必要な環境」というものがある。

その設定をここに記述する。

## 前提

以下を前提とする。

+ CentOS５．５で動いているサーバに仕込む

## TFTPサーバの設定

CentOSのサーバにTFTPサーバを立てる。 ([参考](http://www.ne.jp/asahi/it/life/it/linux/linux_tips/tftp_centos.html))

```bash
yum install tftp tftp-server
# Ubuntu/Debianの場合なら以下。
# sudo apt-get install tftp tftpd
vi /etc/xinetd.d/tftp
# disable = yes → no に変更。
# xinetdの再起動
service xinetd restart
```

公開ディレクトリ設定はデフォルトで `/var/lib/tftpboot` になっているので、ここにファイルを置く。

## CD-ROMの内容をマウント

本質的には関係ないが…KURO−NAS/X4のCDROMのisoイメージを持っているので、マウントしておく。

KURO-NAS/X4 から参照する、ファームウェアイメージをTFTP公開ディレクトリにコピーしておく。

```bash
mkdir /mnt/iso
mount -t iso9660 -o loop ./KURONAS100.iso /mnt/iso
cp /mnt/iso/firmware/* /var/lib/tftpboot/
```

## IPアドレスを「KURO-NASが認識する固定IP」へと振替える

以下の内容で設定する。

```bash
vi /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="yes"
TYPE="Ethernet"
BOOTPROTO=none
IPADDR=192.168.11.1
NETMASK=255.255.255.0
USERCTL=no
PEERDNS=no
IPV6INIT=no
```

## シリアルケーブル(RS232C)でKURO−NAS/X4につなぐ

物理的にコードをつなぐ。

測定方法は[ココ](http://kazuhito-m.github.io/tech/2016/01/14/serial-console-in-linux/)。

## USBメモリにCDROMの内容を全追加してKURO-NAS/X4に刺す

掲題の通り。指して起動。

## 作業用PCとKURO-NAS/X4をルータにつなぐ

`192.168.11.2` を設定した有線ルータを用意し、KURO-NAS/X4とTFTPを仕込んだCentOSのマシンをつなぎ、KURO-NAS/X4の電源を入れる。

KURO-NAS/X4 がファームを読み、CentOSのシリアルコンソールから `# ` のルートコンソールが観測されれば、準備完了。

この後の作業は、 [manual_operation.md](./manual_operation.md) へ。
