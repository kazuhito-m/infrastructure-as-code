## 手動でやった作業の記録

## Nginxの設定

- apt-get install nginx
- vi /etc/nginx/sites-available/miura_wiki.conf
- ln -s /etc/nginx/sites-available/miura_wiki.conf /etc/nginx/sites-enabled/miura_wiki.conf
- sudo apt install certbot python3-certbot-nginx
- sudo certbot --nginx -d miura-wiki.f5.si
  - Ansibleの時どうする？
    - /etc/letsencrypt/archive/miura-wiki.f5.si フォルダが無かったら、実行しようか
    - nginx側とどう折り合いをつけるかがわからないが

### 参考

- https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04-ja

## Growi設定

- apt-get install libatomic1
- curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
- nvm install v16.18.1
- npm install -g npm@6.14.7 yarn
- sudo apt-get install openjdk-17-jdk
- wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
- echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
- sudo apt-get update && sudo apt-get install elasticsearch
- sudo systemctl start elasticsearch
- sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
- sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
- wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
- echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
- sudo apt-get update
- sudo apt-get install mongodb-org
- sudo systemctl enable --now mongod
- wget https://github.com/weseek/growi/archive/refs/tags/v5.1.8.tar.gz
- gunzip ./v5.1.8.tar.gz
- sudo tar xvf ./v5.1.8.tar -C /opt
- sudo rm -rf /opt/growi
- sudo mv /opt/growi-5.1.8 /opt/growi
- cd /opt/growi
- echo "network-timeout 3600000" > .yarnrc
- yarn
- sudo MONGO_URI=mongodb://localhost:27017/growi  ELASTICSEARCH_URI=http://localhost:9200/growi npm start


### RasPIならでわのフロー

- elasticsearch
  - wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.5.1-arm64.deb
  - sudo dpkg -i --force-all --ignore-depends=libc6 elasticsearch-8.5.1-amd64.deb


### 参考

- https://qiita.com/steepay/items/96605cfbdd78995d707f
- https://linuxhint.com/install-elasticsearch-debian/
- https://arkgame.com/2021/12/24/post-303135/
- https://www.mongodb.com/docs/manual/reference/installation-ubuntu-community-troubleshooting/
- http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 Release
- https://docs.npmjs.com/cli/v8/commands/npm-version
- https://qiita.com/guai3/items/4d38dcb8a877951b718a
- https://www.suzu6.net/posts/291-node-max-old-space-size/


## エクスポートデータを作成する方法

旧形式のデータは、新VersionのGROWIではインポート出来ない。

なので「旧→新にアップグレードしてエクスポート」する。

1. nvm install v14.21.1
2. cd /opt/growi && rm -rf ./*
3. git reset --hard HEAD
4. git checkout v4.1.0
5. yarn && MONGO_URI=mongodb://localhost:27017/growi  ELASTICSEARCH_URI=http://localhost:9200/growi npm start
6. サイトでバックアップデータをインポート
7. トップ画面だけは手動で書き換え
8. 停止
9. nvm install v16.18.1
10. cd /opt/growi && rm -rf ./*
11. git reset --hard HEAD
12. git checkout v5.1.8
13. yarn && MONGO_URI=mongodb://localhost:27017/growi  ELASTICSEARCH_URI=http://localhost:9200/growi npm start
14. サイトでバックアップZIPをエクスポート

## やり直しで「RasPI＆DockerでGrowi建てる」お試し

- cd /var/lib && mkdir growi && cd ./growi
- git clone https://github.com/temple1026/growi-docker-compose-pi.git growi
- cd growi && vi docker-compose.yml

Linux minoru 5.15.76-v7+ #1597 SMP Fri Nov 4 12:13:17 GMT 2022 armv7l GNU/Linux


この方策で、上手く行かなかったから断念。別の方策を取る。

## RasPIに最新RaspberyOS入れて、素の手順(否Docker)で動くトコまで行くかためしてみる

- まずは「64bit版RaspberyOS」を入れて、さっき失敗したDockerComposeインストールしてみる
  - そも「RasPI2ModelBでは動かなかった」ので断念
- 次に「RaspberyOS」を入れて、「素で入れる」を試してみる
  - https://qiita.com/steepay/items/96605cfbdd78995d707f これはUbuntu前提だが、いけるとこまで行って観る

## RasPIに最新UbuntuServer入れて、素の手順(否Docker)で動くトコまで行くかためしてみる

- そも64bit版は「起動しなかった」ので、32bitのUbuntuを入れる
  - これで、おそらく「DockerでGrowi入れる」もできなくなったはず…なので素で入れる前提で
    - 実際にやって「出来ない(ビルド中に0以外返す)」を確認(無論、 armv7lで動くコンテナに変えて)
- ip固定
  - https://corgi-lab.com/linux/rpi4-ubuntu-server-2004/#:~:text=%E5%9B%BA%E5%AE%9AIP%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B,-%E3%81%93%E3%81%AE%E3%81%BE%E3%81%BE%E4%BD%BF%E3%81%84%E5%A7%8B%E3%82%81%E3%81%A6&text=%E3%81%BE%E3%81%9A%E3%81%AF%20%2Fetc%2Fnetplan%2F50,%E8%A8%AD%E5%AE%9A%E3%81%AA%E3%81%A9%E3%82%92%E6%9B%B8%E3%81%8D%E8%BE%BC%E3%81%BF%E3%81%BE%E3%81%99%E3%80%82
- apt update && apt upgrade && apt dist-upgrade
- SSH有効
  - https://codechacha.com/ja/ubuntu-install-openssh/
  - apt install openssh-server
  - systemctl enable ssh
  - systemctl start ssh
  - 動かなかったが、以下で解決
    - https://lil.la/archives/5277
- 必要なものインストール
  - apt install byobu
- swapfileの有効化
  - https://centos.bungu-do.jp/archives/65

### Growiのインストール

#### 前準備

- apt-get install libatomic1
- curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
- nvm install v16.18.1
- npm install -g npm@6.14.7 yarn
- sudo apt-get install openjdk-17-jdk

#### エラスティックサーチのインストール

以下らへんを参考に。

- https://mebee.info/2020/05/27/post-11387/
- https://awesome-linus.com/2017/09/07/elasticsearch-5-6-1-install-tar-gz/
- https://qiita.com/takilog/items/21461e0e6ac73965f678
- https://nakamurake-site.com/archives/configuration-of-elasticsearch-kibana-in-raspberry-pi-4/
- https://arkgame.com/2021/03/23/post-269593/

---

- wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.1.tar.gz
- tar zxvf elasticsearch-6.1.1.tar.gz
- cd elasticsearch-6.1.1/
- sysctl -w vm.max_map_count=262144
- vi ./config/jvm.options

```
## GC configuration
# 以下は動かないのでコメントアウト
# -XX:+UseConcMarkSweepGC
# -XX:CMSInitiatingOccupancyFraction=75
# -XX:+UseCMSInitiatingOccupancyOnly
...
-Xms256M
-Xmx256M
```

- vi ./config/elasticsearch.yml

```
bootstrap.system_call_filter: false
network.host: 0.0.0.0
transport.host: localhost
transport.tcp.port: 9300
```

- ./bin/elasticsearch-plugin install analysis-kuromoji
- ./bin/elasticsearch-plugin install analysis-icu
- ./bin/elasticsearch

TODO サービス化

#### MongoDBのインストール

apt-getにmongoあるのだが…インストール時にコケる。

公式のapt-lineを足そうにも、arm32(armhf/armv7l)のアーキテクチャ対応は無い模様。

なので「自力でビルド」することにする。

https://koenaerts.ca/compile-and-install-mongodb-on-raspberry-pi/

---

```bash
apt-get install -y scons build-essential libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev python3-pymongo
ln -s /bin/python3 /bin/python
wget https://fastdl.mongodb.org/src/mongodb-src-r4.0.28.tar.gz
tar xvf ./mongodb-src-r4.0.28.tar.gz
cd mongodb-src-r4.0.28/
cd src/third_party/mozjs-*
./get_sources.sh
./gen-config.sh arm linux
```

と、ここで

```bash
Unknown configuration platform/arm/linux
```

と出て失敗。

恐らく 3.x 系ならビルド出来たのかも知れないが…

これ以上は「Mongoのノウハウの蓄積」になるし、数百円の電気代のために頑張るのもなんだかなぁなので、断念。
