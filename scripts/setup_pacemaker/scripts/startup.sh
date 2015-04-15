#!/bin/bash -x

# デタッチ時に走ることを期待したスクリプト。
# 「最初に一回」の処理に対しては冪等性を考慮し、記述すること。
# author : Kazuhito Miura

# サービス開始(二回目以降はありスタート)
service sshd restart
# tomcat6 は途中で死ぬとゴミを残すので、予め「失敗しないカタチ」で削除実行。
rm -f /var/run/tomcat6.pid
rm -f /var/lock/subsys/tomcat6
service tomcat6 restart
# yumで入れると'mysqld'に、rpmで入れると'mysql'になる。
# service mysqld restart
service mysql restart
# 日に二度Tomcatを上げ直すため、cron起動
service crond restart

# rpmで入れたMySQLでは「初回、カレントディレクトリの".mysql_secret"にrootパスワードを残す」とか、する。
# 末尾パスワード部分のみを取得する。
mysql_root_password=$(cat /.mysql_secret)
mysql_root_password=${mysql_root_password##*: }

# mysqlに外から入れるよう設定(二回目以降も権限系だけはふり直す)
mysql --user=root --password=${mysql_root_password} --connect-expired-password -e "SET PASSWORD FOR root@localhost=PASSWORD('kazuhito');"
mysql --user=root --password=kazuhito -e 'CREATE DATABASE IF NOT EXISTS kazuhito;'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO kazuhito@"10.149.28.%" IDENTIFIED BY "kazuhito";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO kazuhito@"172.17.%.%" IDENTIFIED BY "kazuhito";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO kazuhito@"%" IDENTIFIED BY "kazuhito";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO kazuhito@"localhost" IDENTIFIED BY "kazuhito";'

mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO root@"10.149.28.%" IDENTIFIED BY "kazuhito";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO root@"172.17.%.%" IDENTIFIED BY "kazuhito";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "kazuhito";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO root@"localhost" IDENTIFIED BY "kazuhito";'

# デーモン用にエンドレス実行の何かを置く
tail -f /dev/null

