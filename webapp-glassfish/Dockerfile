FROM centos:centos6

MAINTAINER kazuhito_m

# インストール

RUN yum update -y
RUN yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel openssh-server unzip wget

# 設定書き換え

# 設定ファイル自体置き換え(tomcat)

# root はsshでパスワードログインできるように。
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd

# rootは鍵認証でログインできるように
ADD ./templates/ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# crontab用のファイルを追加。
ADD ./templates/crontab_root /var/spool/cron/root

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]
