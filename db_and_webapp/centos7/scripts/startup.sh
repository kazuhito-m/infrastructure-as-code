#!/bin/bash

# デタッチ時に走ることを期待したスクリプト。
# 「最初に一回」の処理に対しては冪等性を考慮し、記述すること。
# author : kazuhito_m

# サービス開始(二回目以降はリスタート)
service sshd restart

# tomcat6 は途中で死ぬとゴミを残すので、予め「失敗しないカタチ」で削除実行。
rm -f /var/run/tomcat6.pid
rm -f /var/lock/subsys/tomcat6
service tomcat6 restart

# MySql再起動
service mysqld restart

# 日に二度Tomcatを上げ直すため、cron起動
service crond restart

# mysqlに外から入れるよう設定(二回目以降も権限系だけはふり直す)
mysql --user=root --connect-expired-password -e "SET PASSWORD FOR root@localhost=PASSWORD('root');"
mysql --user=root --password=kazuhito -e 'CREATE DATABASE IF NOT EXISTS sample;'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO sample@"%.%.%.%" IDENTIFIED BY "sampleps";'
mysql --user=root --password=kazuhito -e 'GRANT ALL PRIVILEGES ON *.* TO kazuhito@"localhost" IDENTIFIED BY "sampleps";'

# デーモン用にエンドレス実行の何かを置く
tail -f /dev/null
