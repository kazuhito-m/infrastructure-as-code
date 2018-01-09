#!/bin/bash

cd /var/local/letsencrypt/certbot

# let's encrypt から証明書を更新。
./certbot-auto renew \
    --force-renewal \
    -d automation.shcloudio.com \
    -m kazuhito.sumpic@gmail.com \
    --agree-tos \
    -n

./certbot-auto certonly \
    --force-renewal \
    -d automation.shcloudio.com \
    --rsa-key-size 2048 \
    --webroot \
    -w /var/local/nginx_conf.d \
    -d automation.shcloudio.com \
    -m kazuhito.sumpic@gmail.com \
    --agree-tos \
    -n

# nginxリスタート
docker restart nginx
