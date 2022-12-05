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


### node,npm,yarnインストール

```bash
apt-get install libatomic1
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
nvm install v16.18.1
npm install -g npm@6.14.7 yarn
```

### OpenJDKインストール

```bash
apt-get install openjdk-17-jdk
```

### Elasticsearchインストール

TODO 失敗したので、全部削除して、一個下げた6系をインストールしてみる https://www.elastic.co/guide/en/elasticsearch/reference/6.8/deb.html

- wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add 
- apt-get install apt-transport-https
- echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
- apt-get update && apt-get install elasticsearch
- systemctl start elasticsearch
- /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
- /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu

が、systemctl startでコケてしまう。`no such file` なので、起動前の問題のような気はするのだが…。

#### もっと原始的なElaasticsearchインストール

上記でも動かなかったので、バイナリ落として無理から動かす。

rootで動かない、という制約があるので、以下は一般ユーザで実行。

```bash
curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.1.tar.gz
tar zxvf elasticsearch-6.1.1.tar.gz
cd elasticsearch-6.1.1/
sudo sysctl -w vm.max_map_count=262144
vi ./config/jvm.options

## GC configuration
# 以下は動かないのでコメントアウト
# -XX:+UseConcMarkSweepGC
# -XX:CMSInitiatingOccupancyFraction=75
# -XX:+UseCMSInitiatingOccupancyOnly
...
-Xms256M
-Xmx256M

vi ./config/elasticsearch.yml

bootstrap.system_call_filter: false
network.host: 0.0.0.0
transport.host: localhost
transport.tcp.port: 9300

./bin/elasticsearch-plugin install analysis-kuromoji
./bin/elasticsearch-plugin install analysis-icu
./bin/elasticsearch
```

### MongoDBインストール

```bash
curl -L https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl status mongod
systemctl enable mongod
```

### Growiインストール


```bash
apt-get install -y build-essential
curl -LO https://github.com/weseek/growi/archive/refs/tags/v5.1.8.tar.gz
gunzip ./v5.1.8.tar.gz
tar xvf ./v5.1.8.tar -C /opt
rm -rf /opt/growi
mv /opt/growi-5.1.8 /opt/growi
cd /opt/growi
echo "network-timeout 3600000" > .yarnrc
yarn
MONGO_URI=mongodb://localhost:27017/growi  ELASTICSEARCH_URI=http://localhost:9200/growi npm start
```


## 検討事項

- 十分速いなら「無線をOnにして、優先はDHCP化」も
  - そも「インストール直後は無線動いてない」から、そっからだ