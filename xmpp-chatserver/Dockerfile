FROM centos:centos6

MAINTAINER Kazuhito Miura < @kazuhito_m >

# インストール
RUN yum update -y
RUN yum -y install java-1.7.0-openjdk openssh-server mysql-server

# 設定書き換え

# MySQL設定ファイル(ニアリー、ステージング)
# RUN mv /usr/my.cnf /usr/my.cnf.org
# ADD ./templates/my.cnf /usr/my.cnf

# root は空パスワードでログインできるように。
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd

# サービス自動起動登録(再起動とかしないから要らん…かも?)
RUN chkconfig mysqld on

# rootは鍵認証でログインできるように
ADD ./templates/ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# mysqlの設定ファイルをコピー。
ADD ./templates/etc/my.cnf /etc/my.cnf

# Openfireをインストールする材料を取得
RUN mkdir openfire_install
RUN cd openfire_install
RUN curl -L -O http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire-3.9.3-1.i386.rpm
RUN rpm -ivh openfire-*.rpm
RUN chkconfig openfire on

# Opnefireの初期設定
# OpenJDKで入れたJavaの環境変数設定。
ADD ./templates/etc/sysconfig/openfire /etc/sysconfig/openfire
# DB接続など、各種「接続設定」
ADD ./templates/opt/openfire/conf/openfire.xml /tmp/openfire.xml
ADD ./templates/opt/openfire/conf/crowd.properties /tmp/crowd.properties
ADD ./templates/opt/openfire/conf/security.xml /tmp/security.xml

# Openfireの初期設定データを/tmp に放り込む。
ADD ./templates/database/openfire.sql.gz /tmp/openfire.sql.gz
RUN gunzip /tmp/openfire.sql.gz

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]

