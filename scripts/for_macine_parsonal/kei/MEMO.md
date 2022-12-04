# 手動でやったおためし作業の記録

容量不足に苦しんだので、次回入れるときには [構成を絞る](https://www.mk-mode.com/blog/2021/09/02/debian-11-installation-for-small-server/) 感じのインストール方法にしたい。

## サーバ自体へのDebianインストール

- Debian11(bullseye)
- パーティショニング
  - 本体SSD(sda)をすべてext4で `/` に
  - USBメモリ16Gをsdbで `/var` に
- sudo 設定
- apt-get install byobu


## swap作る

```bash
dd if=/dev/zero of=/var/swapfile bs=1M count=2048
mkswap /var/swapfile
chmod 600 /var/swapfile
swapon /var/swapfile
vi /etc/fstab
#/swapfile               swap                   swap    defaults        0 0
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

## Growi

## 検討事項

- 十分速いなら「無線をOnにして、優先はDHCP化」も
  - そも「インストール直後は無線動いてない」から、そっからだ