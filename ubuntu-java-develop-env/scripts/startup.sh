#!/bin/bash

# デタッチ時に走ることを期待したスクリプト。
# 「最初に一回」の処理に対しては冪等性を考慮し、記述すること。
# author : kazuhito_m

# サービス開始(二回目以降はリスタート)
service ssh restart

# VNCを設定
export USER=root
export LANG=ja_JP.UTF-8
vncserver :1 -geometry 1360x768 -depth 24

# デーモン用にエンドレス実行の何かを置く
tail -f /dev/null
