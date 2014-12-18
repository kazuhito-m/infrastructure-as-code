#!/bin/bash -x

# デタッチ時に走ることを期待したスクリプト。
# 「最初に一回」の処理に対しては冪等性を考慮し、記述すること。
# author : kccs miura

# サービス開始(二回目以降はありスタート)
service sshd restart
service mysqld restart
# 日に二度Tomcatを上げ直すため、cron起動
service crond restart

# openfire をまずストップする
service openfire stop


# mysqlに外から入れるよう設定(二回目以降も権限系だけはふり直す)
mysqladmin password password -u root
mysql --user=root --password=password -e 'CREATE DATABASE IF NOT EXISTS openfire;'
mysql --user=root --password=password -e 'GRANT ALL PRIVILEGES ON openfire.* TO root@"%.%.%.%" IDENTIFIED BY "password";'
mysql --user=root --password=password -e 'GRANT ALL PRIVILEGES ON openfire.* TO root@"localhost" IDENTIFIED BY "password";'

# TODO データの流しこみは、現在Omitしている。
# TODO 具体的なユーザなどが決まる場合、 openfile.sql を書き換えるとともに、以下のブロックを蘇らせること。

# Openfire のデフォルトのDBデータを流し込む
# mysql --user=root --password=password openfire < /tmp/openfire.sql

# チャットサーバOpenfireを起動。
service openfire start

# デーモン用にエンドレス実行の何かを置く
tail -f /dev/null
