# 手動セットアップ手順

どうしても「自動にできなかった部分」について、手動でやった操作につきここに記述していく。

## ファームウェアで起動後のrootコンソール作業

基本的には、「日経Linux200903号」の記事に従う。

### ハードディスクにDebianインストール

```bash
./partition.sh
./install.sh -D /dev/sdb1 -m /mnt/usbdisk1 -t vfat .
```

このコマンドを実行以降、設定が終われば自動的に再起動、それ以降は「普通のDebian」として、DHCPでとったIPアドレスで設定、LAN上から参照出来る。

シリアルコンソール上での最後の仕事とし、SSHのインストール。

```bash
apt-get update
apt-get -y install ssh
```

## Debian上からの通常作業


+ gitからこのリポジトリを引っ張ってきて、このファイルを作成した
+ yum install -y git fabric
+
+
+
+
+
+
+
