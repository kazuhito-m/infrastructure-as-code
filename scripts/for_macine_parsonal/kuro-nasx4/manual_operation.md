# 手動セットアップ手順

どうしても「自動にできなかった部分」について、手動でやった操作につきここに記述していく。

## ファームウェアで起動後のrootコンソール作業

基本的には、「日経Linux200903号」の記事に従う。

### ハードディスクにDebianインストール

```bash
./partition.sh
./install.sh -D /dev/sdb1 -m /mnt/usbdisk1 -t vfat .
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
