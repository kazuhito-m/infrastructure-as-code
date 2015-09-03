FROM ubuntu:15.10

MAINTAINER kazuhito_m

# インストール

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y openssh-server 
RUN apt-get install -y openjdk-8-jdk maven git vim
RUN apt-get install -y tomcat8 tomcat8-admin

# そのままapt-getでインストールするとパスワードを聞かれる箇所で止まってしまうので、予め設定しておく。この例ではパスワードは「root」。
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections && \
    apt-get -y install mysql-server

# my.cnfを編集
# bind-address行をコメントアウトして、外部から接続出来るようにする
RUN sed -i -e "s/^bind-address\s*=\s*\(.*\)/#bind-address = \1/" /etc/mysql/my.cnf

# デフォルトの文字コードをUTF-8に設定
RUN sed -i -e "s/\(\[mysqld\]\)/\1\ncharacter-set-server = utf8/g" /etc/mysql/my.cnf
RUN sed -i -e "s/\(\[client\]\)/\1\ndefault-character-set = utf8/g" /etc/mysql/my.cnf
RUN sed -i -e "s/\(\[mysqldump\]\)/\1\ndefault-character-set = utf8/g" /etc/mysql/my.cnf
RUN sed -i -e "s/\(\[mysql\]\)/\1\ndefault-character-set = utf8/g" /etc/mysql/my.cnf

# 設定書き換え

# 設定ファイル自体置き換え(tomcat)

# Manager管理ユーザ設定
RUN mv /etc/tomcat8/tomcat-users.xml  /etc/tomcat8/tomcat-users.xml.org
ADD ./templates/tomcat-users.xml /etc/tomcat8/tomcat-users.xml
RUN chown root:tomcat8 /etc/tomcat8/tomcat-users.xml
RUN chmod 664 /etc/tomcat8/tomcat-users.xml

# root はsshでパスワードログインできるように。
RUN sed -ri 's/^PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd

# rootは鍵認証でログインできるように
ADD ./templates/ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# サービス自動起動登録(再起動とかしないから要らん…かも?)
# …はインストール直後にserviceがONになってるものばっかりだから、要らんと思う。
# 必要ならば、以下を入れる
# apt-get install -y sysv-rc-conf 
# sysv-rc-conf mysql on

# crontab用のファイルを追加。
ADD ./templates/crontab_root /var/spool/cron/root

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]
