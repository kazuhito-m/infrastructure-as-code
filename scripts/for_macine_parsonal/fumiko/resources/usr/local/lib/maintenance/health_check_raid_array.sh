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
SELF_HOST_IP=$(host ${SELF_HOST_DOMAIN_NAME} | sed 's/.*address //g')

# Path調整
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# 自身スクリプトまで移動。
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

# 設定読込
source ../../etc/maintenance/slack.conf

# main part

echo "${0} start at `date '+%Y/%m/%d %R'`"

cat /proc/mdstat | grep 'blocks' | grep '\[UU\]'
if [ $? -eq 0 ]; then
    echo '異常無し。正常終了。'
    echo "${0} end   at `date '+%Y/%m/%d %R'`"
    exit 0
fi

## 異常時

mdstat=$(/proc/mdstat)

data=`cat <<_EOT_
{
     "attachments": [
        {
	        "mrkdwn_in": ["text"],
            "color": "danger",
            "title": "MD Array Invalid Status",
            "pretext": "${SELF_HOST_NAME} のソフトウェアRAIDのArrayの状態異常です。",
            "fields": [
                {
                    "title": "Host Name(IP Address)",
                    "value": "${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})",
                    "short": false
                },
                {
                    "title": "Status Detail",
                    "value": "cat /proc/mdadm said... \\\`\\\`\\\`${mdstat}\\\`\\\`\\\` ",
                    "short": true
                },
            ],
        }
    ]
}
_EOT_`

./slack_send.sh "${data}" ${SLACK_WEBHOOK_URL}

echo '異常在り。異常終了。'
echo "${0} end   at `date '+%Y/%m/%d %R'`"

exit 1