#!/bin/bash

#
# lm_sensours を使い、ログの出力と、
# 規定温度を越えた場合の警告をDiscordに通知するスクリプト。
#
# cronにて「1分に一度実行」を前提とする。
#

set -eu

# constant

LOG_DIR=/var/log/sensors
LOG_FILE=${LOG_DIR}/cpu_temperature.log

NOTIFICATION_INTERVAL_MINUTES=5

WARNING_CELSIUS=83
DANGER_CELSIUS=90

SELF_HOST_NAME=$(hostname)
SELF_HOST_DOMAIN_NAME=$(domainname -A | cut -d' ' -f1)
SELF_HOST_IP=$(host ${SELF_HOST_DOMAIN_NAME} | sed 's/.*address //g')

# functions

function notify_chat() {
  status_code=${1}
  celsius=${2}

  status='Warning'
  status_comment='高温'
  color_code=16776960
  if [ ${status_code} = 'd' ]; then
    status='Dangerous'
    status_comment='非常に高く、危険な状態'
    color_code=16711680
  fi

  data=`cat <<_EOT_
{
     "embeds": [
        {
            "color": ${color_code},
            "title": "CPU Temperature ${status}",
            "description": "\\\`${SELF_HOST_NAME}\\\` のCPU温度が${status_comment}です。",
            "fields": [
                {
                    "name": "Host Name(IP Address)",
                    "value": "\\\`${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})\\\`",
                    "inline": false
                },
                {
                    "name": "CPU温度",
                    "value": "\\\`摂氏 ${celsius} 度\\\`",
                    "inline": false
                }
            ]
        }
    ]
}
_EOT_`

  ./chat_send.sh "${data}" ${CHAT_WEBHOOK_URL}
}

# initialize

## 自身スクリプトまで移動。
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

## 設定読込
source ../../etc/maintenance/chat.conf

# main part

## logging

ls ${LOG_DIR} > /dev/null || mkdir ${LOG_DIR}
ls ${LOG_FILE} > /dev/null || touch ${LOG_FILE} && chmod +r ${LOG_FILE}

celsius=$(sensors -u | grep 'temp1_input:' | sed 's/.*://g')
echo "$(date '+%Y-%m-%dT%H:%M:%S')${celsius}" >> ${LOG_FILE}

## notification

if [ $(echo "${celsius} > ${WARNING_CELSIUS}" | bc) -eq 1 ]; then
  status_code='w'
  if [ $(echo "${celsius} > ${DANGER_CELSIUS}" | bc) -eq 1 ]; then
    status_code='d'
  fi

  if [ $(( $(date '+%M') % ${NOTIFICATION_INTERVAL_MINUTES} )) -eq 0 ] ; then
    notify_chat ${status_code} ${celsius}
  fi
fi

exit 0
