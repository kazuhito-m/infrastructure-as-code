FROM ubuntu:14.04

MAINTAINER kazuhito_m

# インストール

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server 

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
