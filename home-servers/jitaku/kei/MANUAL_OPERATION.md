# 手動セットアップ手順

どうしても「自動にできなかった部分」について、手動でやった操作につきここに記述していく。

## インストール時

ディスプレイをつなぎ、`netinst` のDebianUSBメモリを刺し、以下のオペレー書hんを行う

インストーラに従い、ほぼデフォルトで入るが、以下程度は入れる。

+ 日本語
+ リポジトリは国内
+ パーティションは「自力」で「すべてを割り当てる」にする
+ デフォルトインストールパッケージはすべてをクリアした上で
  + SSHサーバ
  + 標準システムユーティリティ

## 直後

最初に以下の設定を行う。(以降の作業、指定がなければroot作業)

### 最低限のインストールのためのツールのインストール

```bash
apt-get install -y sudo parted python3
```

### sudo有効設定

必要なユーザをsudoグループに入れる。

```bash
adduser kazuhito sudo
```

おそらく、suでrootになってると、戻っても有効になってないので、ログアウトか再起動後確認。

## 外付けUSB接続SSDの初期化

2023/03時点の暫定だが、USB接続で作業用SSDをつなぐ。

パーティション作成/フォーマットする。

※くれぐれも、 `lsblk` などで「対象のSSDか」「対象以外のをフォーマットしないか」を注意する。

```bash
lsblk
# 今回は /dev/sdc だった

su -

fdisk /dev/sdc
d
n
p

p
w
# これにて /dev/sdc1 のパーティションが出来るはず。

mkfs.ext4 /dev/sdc1
```

## プロビジョニング

以下を実行し、Ansibleを適用する。

```bash
./run.sh
```

## Growiデータのインポート

少し癖があるので、手順を記載

1. 設定のアプリ設定から、メンテナンスモードに設定する
2. 設定のデータインポートに、バックアップファイルを読み込ませる
3. 全てにチェックを付け、出来る限り `Flush and insert` に変える
    - ただし、`Pages` と `Revisions` については `Upsert` に設定する
4. インポートを実行する

データによるのか「`/` (トップ記事)がインポートされないことがある」ので、その場合はテキストデータでその記事だけ編集する。

---

## 定期メンテの操作

運用している途中での特殊操作について、記述する。

### ストレージ(USBメモリ)同士のイメージバックアップとレストア

現在、同容量(128GB)のUSBメモリを二本指しており、先に認識するほうのUSBメモリを実運用、もう一本を「メインが破壊された場合のコールドスタンバイ用のストレージ」として、一週間ごと(cron.weekly任せ)にイメージコピーを行っている。

メインストレージが破損して動かなく成った場合、以下の手順で「正常運用」に戻す。

1. 電源を切る
2. 先に認識するほう(刺している側/本体後側からみて左)のUSBメモリを抜く
3. 右のUSBメモリを、元メインが在った左のスロットに刺し直す
4. 電源を入れる
5. おそらく、ジャーナルがおかしくなっていると思われるので、grubで `fsck` を実行して修復する
   - https://www.linuxquestions.org/questions/linux-desktop-74/boot-problems-with-ssd-drive-post-grub-on-manjaro-4175622555/#post5812671
   - 具体的には `fsck -f /dev/sda1` を打ち、画面の表示を確認しながら対処
6. 再起動し、正常に立ち上がるかを確認

### バックアップに取ってたGrowiデータのレストア

Wikiデータであるmonogdbとアプリが使う画像系、また元となったdocker-composeのソースは、gzipの形でファイルサーバにコピーする仕組みに成っている。

そのバックアップのtgzからGrowiのデータを復帰させる方法を記述する。

```bash
cd /var/lib/growi/docker_compose
sudo docker compose down
cd /tmp
# 当該tgzをコピーしてくる
tar xzf backup_growi_*.tgz
sudo rm -rf /var/lib/growi/data/
sudo mv ./var/lib/growi/data/ /var/lib/growi/data/
cd /var/lib/growi/docker_compose
sudo docker compose up -d
```

### バックアップを取っているdelugeデータのレストア

delugeアプリの設定とDL中のキャッシュ、また元となったdocker-composeファイルは、tgzの形でファイルサーバにコピーをする仕組みになっている。

※DLしたファイル自体はバックアップしていない。

サーバが大破壊orディスクが死んだなど、ダメになった場合のため、サーバプロビジョニング後にデータを復帰させる方法を記述する。

```bash
su -
cd /additionalssd/deluge
# docker-composeでデプロイしているアプリを止める。
docker compose down
docker compose rm
# 一回起動したことにより出来た設定やフォルダを削除する。
rm -rf ./config ./progress
# バックアップファイルを展開する。
cd /additionalssd
backup_dir=/dev/nfs/fumiko/Backup/machine/RealMachine/server/kei/deluge
tar xzf $(ls -t ${backup_dir}/*.tgz | head -n 1)
# docker-composeで再度デプロイ。
cd /additionalssd/deluge
docker compose up -d
```

復帰後、UIから `Error` な要素を片っ端から削除すること。
