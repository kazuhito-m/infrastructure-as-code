#!/bin/bash

# cronを起動しなおし
# service cron start

# 設定ファイルを環境変数により書き換え
cat /etc/nginx/conf.d/proxy_and_repo.conf | sed -e "s/\\\$SERVER_NAME/${SERVER_NAME}/g" > /etc/nginx/conf.d/proxy_and_repo.conf.modify
mv /etc/nginx/conf.d/proxy_and_repo.conf.modify /etc/nginx/conf.d/proxy_and_repo.conf

# cronの再起動
service cron restart

# 一回目の「Let's encryptによる証明書発行」を行う。
# ※まだnginxが動き出す前なので「自力でWebアプリがうごかす」オプションで開始する。
echo "${SERVER_NAME} の証明書を新規取得します。"
certbot certonly --standalone -d ${SERVER_NAME} -m admin@${SERVER_NAME} --agree-tos -n ${SERTBOT_OPTIONS}
if [ ${?} != 0 ]; then
    echo "証明書の取得に失敗しました。domain:${SERVER_NAME}"
    exit 1
fi

echo "nginx 起動。"
nginx -g 'daemon off;'
