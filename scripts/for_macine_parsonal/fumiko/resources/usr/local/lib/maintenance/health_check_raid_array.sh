#!/bin/bash

# 
#  ソフトウェアRAID(md)のArrayが正常かをチェックし異常ならSlackに報告するスクリプト。
#
# Premise
#   以下のコマンドを必要とする
#     cat grep curl
#

# 定数
SELF_HOST_NAME=$(hostname)
SELF_HOST_DOMAIN_NAME=${SELF_HOST_NAME}.local.miu2.f5.si
SELF_HOST_IP=$(host ${SELF_HOST_DOMAIN_NAME})

# 設定読込
source ../../etc/maintenance/slack.conf

# 自身スクリプトまで移動。
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}



echo ${SLACK_WEBHOOK_URL}




data=`cat <<_EOT_
{
     "attachments": [
        {
	        "mrkdwn_in": ["text"],
            "color": "error",
            "pretext": "${SELF_HOST_NAME} のソフトウェアRAIDのArrayの状態異常です。",
            "fields": [
                {
                    "title": "Host Name(IP Address)",
                    "value": "${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})",
                    "short": false
                },
                {
                    "title": "ContainerTag/Version",
                    "value": "${CI_BUILD_TAG}",
                    "short": false
                },
            ],
        }
    ]
}
_EOT_`

./slack_send.sh "${data}" ${SLACK_WEBHOOK_URL}