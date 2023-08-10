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
LOG_FILE=${LOG_DIR}/temperature.log

NOTIFICATION_INTERVAL_MINUTES=5

WARNING_CELSIUS=83
DANGER_CELSIUS=90

SELF_HOST_NAME=$(hostname)

# functions

function notify_chat() {
  status=${1}
  celsius=${2}

  status_comment='高温'
  color_code=16776960
  if [ ${status} = "d" ]; then
    status_comment='非常に高く、危険な状態'
    color_code=16711680
  fi

  data=`cat <<_EOT_
{
     "embeds": [
        {
            "color": ${color_code},
            "title": "MD Array Invalid Status",
            "description": "\\\`${SELF_HOST_NAME}\\\` のCPU温度が${status_comment}です。",
            "fields": [
                {
                    "name": "CPU温度",
                    "value": "\\\`${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})\\\`",
                    "inline": false
                }
            ]
        }
    ]
}
_EOT_`

./chat_send.sh "${data}" ${CHAT_WEBHOOK_URL}}

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
  status='w'
  if [ $(echo "${celsius} > ${DANGER_CELSIUS}" | bc) -eq 1 ]; then
    status='d'
  fi

  if [ $(( $(date '+%M') % ${NOTIFICATION_INTERVAL_MINUTES} )) -eq 0 ] ; then
    notify_chat ${status} ${celsius}
  fi
fi

exit 0

