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
vi /etc/xinetd.d/tftp
# disable = yes → no に変更。
# xinetdの再起動
service xinetd restart
```

公開ディレクトリ設定はデフォルトで `/var/lib/tftpboot` になっているので、ここにファイルを置く。

## CD-ROMの内容をマウント

本質的には関係ないが…KURO−NAS/X4のCDROMのisoイメージを持っているので、マウントしておく。

```bash
mount -t iso9660 -o loop ./KURONAS100.iso /var/lib/tftpboot/
```

## シリアルケーブル(RS232C)でKURO−NAS/X4につなぐ

物理的にコードをつなぐ。

測定方法は[ココ](http://kazuhito-m.github.io/tech/2016/01/14/serial-console-in-linux/)。

## IPアドレスを「KURO-NASが認識する固定IP」へと振替える
