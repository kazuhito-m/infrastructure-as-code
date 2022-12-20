# 手動セットアップ手順

どうしても「自動にできなかった部分」について、手動でやった操作につきここに記述していく。

## インストール時

ディスプレイが壊れているので、USBのインストールメディアなどからの「画面を操作したインストール」は出来ない。

そのため、以下のやり方をする

1. DebianをUSBへBoot可能でインストールし、それを2本作る
   1. BootフラグをOnとすると共に、grubもそのUSBに入れる
   2. 片方は「Boot出来る最低限の容量(現在のDebianでは2GBくらい？)
2. 片方のUSBでPCをブートする
3. もう片方(上記の最低限の容量の方)をddコマンドで「PCの中にあるSSD」にイメージコピー
4. すべてのUSBを抜いて、PCを再起動
   1. 外部ディスプレイにloginコンソールを表示することが出来たら成功


### SSDコピー用のUSBイメージディスクの作り方

`netinst` のイメージを焼き、テキストインストールする。

インストーラに従い、ほぼデフォルトで入れたが、選んだとこといえば

+ 日本語
+ リポジトリは国内
+ パーティションは「自力」で「すべてを割り当てる」にする
+ デフォルトインストールパッケージはすべてをクリアした上で
  + SSHサーバ
  + 標準システムユーティリティ

## 直後

最初に以下の設定を行います。(以降の作業、指定がなければroot作業)

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

### パーティションを拡張する

USBメモリにインストール段階では「最低限の容量」しか割り振ってないので、内蔵SSDの容量上限まで拡張する。

```bash
parted
#----
print
resizepart 1 120GB　  # 表示されたSSDの上限にして実行する。
q
```

partedに出た後、確認と「FileSystem上のリサイズ」も行う。

```bash
cat /proc/partitions
resize2fs /dev/sda1
df -h /
```

dfコマンド上の容量が変わっていたら、リサイズ終了。


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
---

## その他の設定

- フタがしまってもサスペンドしないようにする
  - https://def-4.com/debian-note-suspend-ignore/
  - しかし、この指定がなくとも、このハードはフタ閉じても動き続けるので、対応は要らないかな？