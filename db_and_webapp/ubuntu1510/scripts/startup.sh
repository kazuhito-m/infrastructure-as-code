#!/bin/bash

# デタッチ時に走ることを期待したスクリプト。
# 「最初に一回」の処理に対しては冪等性を考慮し、記述すること。
# author : kazuhito_m

# サービス開始(二回目以降はリスタート)
service ssh restart

# tomcat6 は途中で死ぬとゴミを残すので、予め「失敗しないカタチ」で削除実行。
rm -f /var/run/tomcat8.pid
service tomcat8 restart

# MySql再起動

# DBが行方不明だっつーエラーを吐きやがるので、事前に教ええる
mysql_install_db --datadir=/var/lib/mysql --user=mysql
service mysql restart

# 日に二度Tomcatを上げ直すため、cron起動
# service cron restart

# Dockerfileサイドで「root:rootをパスワードに設定」ってやってるはずなのに…rootをnonpassで通しやがる。TODOや

# mysqlに外から入れるよう設定(二回目以降も権限系だけはふり直す)
mysql --user=root -e 'CREATE DATABASE IF NOT EXISTS sample;'
mysql --user=root -e 'GRANT ALL PRIVILEGES ON *.* TO sample@"%.%.%.%" IDENTIFIED BY "sampleps";'
mysql --user=root -e 'GRANT ALL PRIVILEGES ON *.* TO sample@"localhost" IDENTIFIED BY "sampleps";'
mysql --user=root -e 'GRANT ALL PRIVILEGES ON *.* TO root@"%.%.%.%" IDENTIFIED BY "root";'
mysql --user=root -e 'GRANT ALL PRIVILEGES ON *.* TO root@"localhost" IDENTIFIED BY "root";'

# デーモン用にエンドレス実行の何かを置く
tail -f /dev/null
