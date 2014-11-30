FROM ubuntu:14.10

MAINTAINER kazuhito_m

# インストール
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nodejs npm

# ssh サーバインストール & 設定
RUN apt-get install -y openssh-server
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]
