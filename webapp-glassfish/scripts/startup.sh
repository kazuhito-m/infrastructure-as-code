#!/bin/bash

# デタッチ時に走ることを期待したスクリプト。
# 「最初に一回」の処理に対しては冪等性を考慮し、記述すること。
# author : kazuhito_m

# サービス開始(二回目以降はリスタート)
service sshd restart

# 日に二度Tomcatを上げ直すため、cron起動
service crond restart

# デーモン用にエンドレス実行の何かを置く
tail -f /dev/null
