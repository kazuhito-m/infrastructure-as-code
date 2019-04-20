#!/bin/bash
#
# インベントリに書かれてる全てのHostに「ワンライナーのコマンド」を投げるスクリプト。
#
# 以下の環境変数を期待する。
#   CAC_KEY_FILE01 : サーバへの共通の鍵ファイルの「在りか(path)」を指定する。
#   USERNAME : サーバ側で共通に使うログインユーザ名。
#   SUDO_PASSWORD : サーバ側に共通で使うsudo時のパスワード。
#

if [ -z "${CAC_KEY_FILE01}" ] ; then
    echo 'キーファイルの環境変数 CAC_KEY_FILE01 が未設定です。'
    exit 1
fi
if [ -z "${SUDO_PASSWORD}" ] ; then
    echo 'サーバのsudo時パスワードの環境変数 SUDO_PASSWORD が未設定です。'
    exit 2
fi

command=${1}
echo "各サーバで実行されるコマンド:${command}"

# 「このスクリプトがある場所」まで移動
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

for i in $(cat hosts | grep -v '^\[.*') ; do
    ssh -t -i ${CAC_KEY_FILE01} ${USERNAME}@${i} "echo ${SUDO_PASSWORD} | sudo -S ${command}"
done
