# hachiro サーバのお試しいろいろ。

## Docker入れてGrowi動くかどうかみてみる

このマシンでDockerGrowi動くかどうか観てみる。

```bash
apt-get remove docker docker.io containerd runc
apt-get update
apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker run hello-world
```

## Growi入れる

```bash
apt install -y unzip
curl -OL https://github.com/weseek/growi-docker-compose/archive/refs/heads/master.zip
unzip *.zip
cd ./growi-docker-*
vi docker-compose.yml
docker compose up
```

## Growiデータをインポートする

少し癖があるので、手順を記載

1. 設定のアプリ設定から、メンテナンスモードに設定する
2. 設定のデータインポートに、バックアップファイルを読み込ませる
3. 全てにチェックを付け、出来る限り `Flush and insert` に変える
    - ただし、`Pages` と `Revisions` については `Upsert` に設定する
4. インポートを実行する

---

## その他の設定

- フタがしまってもサスペンドしないようにする
  - https://def-4.com/debian-note-suspend-ignore/
