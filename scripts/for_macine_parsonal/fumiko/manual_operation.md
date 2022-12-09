# 手動セットアップ手順

どうしても「自動にできなかった部分」について、手動でやった操作につきここに記述していく。

## インストール時

最新のDebianをUSBから入れる。

インストーラに従い、ほぼデフォルトで入れたが、選んだとこといえば

+ 日本語
+ Host名は"fumiko"に
+ ローカルドメインは"local.miu2.f5.si"
+ リポジトリは国内
+ パーティションはSSD一個だけつないでパーティション２つ(ふたつ目はSwap)にウィザードで決定
+ デフォルトインストールパッケージはすべてをクリアした上で
  + SSHサーバ
  + 標準システムユーティリティ


## 直後

最初に以下の設定を行います。(以降の作業、指定がなければroot作業)


### 最低限のインストールのためのツールのインストール

```bash
apt-get install sudo git parted gdisk
```

### sudo有効設定

必要なユーザをsudoグループに入れる。

```bash
gpasswd -a kazuhito sudo 
```

おそらく、suでrootになってると、戻っても有効になってないので、ログアウトか再起動後確認。

### gitの設定

通常ユーザの「その人に沿ったgitの設定」を行う。

ユーザごとなので、ここには書かない。

## ディスク系の設定

### ディスク状況を調べる

```bash
ls -l /dev/sd*
brw-rw---- 1 root disk 8,  0  1月  4 08:39 /dev/sda
brw-rw---- 1 root disk 8,  1  1月  4 08:39 /dev/sda1
brw-rw---- 1 root disk 8,  2  1月  4 08:39 /dev/sda2
brw-rw---- 1 root disk 8,  5  1月  4 08:39 /dev/sda5
brw-rw---- 1 root disk 8, 16  1月  4 08:39 /dev/sdb
brw-rw---- 1 root disk 8, 32  1月  4 08:39 /dev/sdc
brw-rw---- 1 root disk 8, 48  1月  4 08:39 /dev/sdd
```

４台認識、うち一台はシステムなので、 b,c,dをpartedを使って初期化。(fdiskではGPTを扱えず２TB以上は設定できないため)

```bash
sudo parted /dev/sdc

mktable
New disk label type ? GPT

mkpart primary 0% 100% # これ１文でコマンド

quit
```
一応タイプ設定しとく。

```bash
sudo fdisk /dev/sdc
:t
Partition type (type L to list all types): fd
:w
```

上記を、HDD分繰り返す。

### ansibleでRAID0組む

この後、ansibleでタスクを実行

```bash
./setup_sample.sh
```

(テスト時は test.sh, test_ansible_only.sh)

サーバに入り、構築状況をwatchする。

```bash
watch -n 1 cat /proc/mdstat
```

この構築に8hくらいかかるので、この日の作業はここで一区切りだと思われる。

## ファイルシステム構築

### fs初期化

```bash
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/test
sudo mount -t ext4 /dev/md0 /mnt/test
sudo mv /home/* /mnt/test/
# fstabにmount設定追加
sudo vi /etc/fstab
# 末尾に追加
/dev/md0　/　ext4　errors=remount-ro 0 1
```

再起動して、mount状況を確認。
