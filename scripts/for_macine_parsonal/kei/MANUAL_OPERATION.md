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
