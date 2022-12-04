# 手動でやったおためし作業の記録

容量不足に苦しんだので、次回入れるときには [構成を絞る](https://www.mk-mode.com/blog/2021/09/02/debian-11-installation-for-small-server/) 感じのインストール方法にしたい。

## サーバ自体へのDebianインストール

- Debian11(bullseye)
  - netinst用のDebianInstallイメージISOをUSBメモリに写像
  - USB端子に刺して起動
- パーティショニング
  - 本体SSD(sda)をすべてext4で `/` に
  - USBメモリ16Gをsdbで `/var` に
- インストール時には「taskselの全てを解除」する
- apt-get install -y byobu openssh-server sudo curl gpg
- systemctl enable ssh && systemctl start ssh
- sudo 設定
  - adduser kazuhito sudo


## swap作る

```bash
dd if=/dev/zero of=/var/swapfile bs=1M count=2048
mkswap /var/swapfile
chmod 600 /var/swapfile
swapon /var/swapfile
vi /etc/fstab
#/var/swapfile               swap                   swap    defaults        0 0
```

## dockerインストール

最初からaptに入ってるやつもやってみたが、恐らく良くないというのがTwtter見てての意見だったので、[公式](https://matsuand.github.io/docs.docker.jp.onthefly/engine/install/debian/)に従う。


```bash
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# composeのインストール＆設定
DOCKER_CONFIG=/usr/local/lib/docker
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

```

## Growiのインストール


```bashl
apt install -y unzip
curl -OL https://github.com/weseek/growi-docker-compose/archive/refs/heads/master.zip
unzip *.zip


docker-compose up
```

### 順調…だったのだが

どーしても、dockernize コマンドで「Elasticserchとつながらない」旨が出て、appがexit code 1で死ぬ。

elasticsearchにつながらないせいで死んでるかはわからないが、接続不能を連打したのち、アベンドでループ。

いろいろためしたが「仮想機なら難なく起動する」ので、「機種依存(Dockerで？そりゃないよ…)」だと考え、断念。

通常のパッケージインストールでGROWIを動かす方針にする。(インストールはAnsibleで行う方向で)


## 手動でDocker使わずGROWIインストール

- apt-get install libatomic1
- curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
- nvm install v16.18.1
- npm install -g npm@6.14.7 yarn
- sudo apt-get install openjdk-17-jdk
- curl https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
- echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
- apt-get update && apt-get install elasticsearch
- systemctl start elasticsearch
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
- cd /opt/growi && yarn
- sudo MONGO_URI=mongodb://localhost:27017/growi  ELASTICSEARCH_URI=http://localhost:9200/growi npm start



## 検討事項

- 十分速いなら「無線をOnにして、優先はDHCP化」も
  - そも「インストール直後は無線動いてない」から、そっからだ