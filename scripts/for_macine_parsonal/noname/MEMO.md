# hachiro サーバのお試しいろいろ。

## Docker入れてGrowi動くかどうかみてみる

このマシンでDockerGrowi動くかどうか観てみる。

```bash
apt install docker.io docker-compose
docker run hello-world
```

## Growi入れる

```bash
cd /var/lib
git clone https://github.com/weseek/growi-docker-compose.git growi
cd growi && vi docker-compose.yml
docker-compose up
```

__解ってたが…「i386のイメージが尽くない」ので断念。__

## 自力で原始的に入れる



---

## その他の設定

- フタがしまってもサスペンドしないようにする
  - https://def-4.com/debian-note-suspend-ignore/