# 手動セットアップ手順

どうしても「自動にできなかった部分」について、手動でやった操作につきここに記述していく。

## インストール時

最新のDebianをUSBから入れる。

インストーラに従い、ほぼデフォルトで入れたが、選んだとこといえば

+ 日本語
+ Host名は"fumiko"に
+ ローカルドメインは"local.sumpic.orz.hm"
+ リポジトリは国内
+ パーティションはSSD一個だけつないでパーティション２つ(ふたつ目はSwap)にウィザードで決定
+ デフォルトインストールパッケージはすべてをクリアした上で
  + SSHサーバ
  + 標準システムユーティリティ


## 直後

最初に以下の設定を行います。(以降の作業、指定がなければroot作業)


### 最低限のインストールのためのツールのインストール

```bash
apt-get install sudo git fabric
```

### sudo有効設定

必要なユーザをsudoグループに入れる。

```bash
usermod -G sudo hogehoge
```

おそらく、suでrootになってると、戻っても有効になってないので、ログアウトか再起動後確認。

### gitの設定

通常ユーザの「その人に沿ったgitの設定」を行う。

ユーザごとなので、ここには書かない。

## ディスク系の設定

### ディスク状況を調べる

```bash
ls -l /devsd*
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
mkpart primary 0% 100%
```
一応タイプ設定しとく。

```bash
sudo fdisk /dev/sdc
:t
Partition type (type L to list all types): 21
:w
```
