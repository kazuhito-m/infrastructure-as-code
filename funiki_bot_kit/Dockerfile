FROM ubuntu:14.10

MAINTAINER kazuhito_m

# インストール
RUN apt-get update
RUN apt-get upgrade -y
# 基本的なソフトは予め入れる
RUN apt-get install -y language-pack-ja openssh-server git curl openjdk-8-jre

# Timezone/locale 設定
RUN update-locale LANG=ja_JP.UTF-8
RUN echo "LC_ALL=ja_JP.UTF-8" >> /etc/default/locale
RUN mv /etc/localtime /etc/localtime.org
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ssh サーバ 設定
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 一般ユーザ追加。
RUN adduser hubot
RUN echo 'hubot:hubot' | chpasswd

# # redis インストール
RUN apt-get install -y redis-server

# nodejsの設定
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:chris-lea/node.js ; apt-get update
RUN apt-get install -y nodejs redis-server

# hubot インストール
RUN npm install -g coffee-script hubot yo generator-hubot

# git clone だけして、funiki-hubot の下地までを作っておく。
RUN cd /home/hubot ; git clone https://github.com/kazuhito-m/funiki-hubot.git
RUN chown hubot:hubot /home/hubot/funiki-hubot

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]
