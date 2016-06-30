FROM ubuntu:latest

MAINTAINER kazuhito_m

# インストール

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server xfce4 tightvncserver language-pack-ja fonts-vlgothic language-pack-ja ibus-mozc firefox openjdk-8-jdk 

# 日本語化
RUN update-locale LANG=ja_JP.UTF-8 ; mv /etc/localtime{,.org} ; ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# root はsshでパスワードログインできるように。
RUN sed -ri 's/^PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd

# rootは鍵認証でログインできるように
ADD ./templates/ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]
