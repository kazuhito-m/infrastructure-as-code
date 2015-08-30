FROM centos:centos7

MAINTAINER kazuhito_m

# インストール

# RUN yum update -y
# なぜかうまくいかない…なんだこれ
RUN yum -y install java-1.8.0-openjdk  git
RUN yum -y install openssh-server
RUN yum -y install tomcat tomcat-webapps tomcat-admin-webapps
RUN yum -y install mariadb-server

# 設定書き換え

# MySQL設定ファイル
RUN mv /etc/my.cnf /etc/my.cnf.org
ADD ./templates/my.cnf /etc/my.cnf

# 設定ファイル自体置き換え(tomcat)

# Manager管理ユーザ設定
RUN mv /etc/tomcat/tomcat-users.xml  /etc/tomcat/tomcat-users.xml.org
ADD ./templates/tomcat-users.xml /etc/tomcat/tomcat-users.xml
RUN chown root:tomcat /etc/tomcat/tomcat-users.xml
RUN chmod 664 /etc/tomcat/tomcat-users.xml
# メモリ増加設定
RUN cp -avr /etc/tomcat/tomcat.conf /etc/tomcat/tomcat.conf.org
RUN echo 'CATALINA_OPTS="-server -Xms2048m -Xmx4096m -XX:PermSize=2048m -XX:MaxPermSize=4096m -XX:NewSize=512m"' >> /etc/tomcat/tomcat.conf
# tomcat についているサンプルのWebアプリを削除(つかわんやろ…)
RUN rm -rf /var/lib/tomcat/webapps/examples /var/lib/tomcat/webapps/sample

# root はsshでパスワードログインできるように。
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd

# rootは鍵認証でログインできるように
ADD ./templates/ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# サービス自動起動登録(再起動とかしないから要らん…かも?)
# RUN chkconfig mysqld on

# crontab用のファイルを追加。
ADD ./templates/crontab_root /var/spool/cron/root

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
# CMD ["/usr/local/bin/startup.sh"]
