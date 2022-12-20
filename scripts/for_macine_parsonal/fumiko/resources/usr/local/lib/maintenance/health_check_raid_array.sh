#!/bin/bash

# 
# ソフトウェアRAID(md)のArrayが正常かをチェックし異常ならチャットに報告するスクリプト。
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
source ../../etc/maintenance/chat.conf

# main part

echo "${0} start at `date '+%Y/%m/%d %R'`"

cat /proc/mdstat | grep 'blocks' | grep '\[UU\]'
if [ $? -eq 0 ]; then
    echo '異常無し。正常終了。'
    echo "${0} end   at `date '+%Y/%m/%d %R'`"
    exit 0
fi

## 異常時

mdstat=$(cat /proc/mdstat | sed -z 's/\n/\\n/g')
mdadm_detail=$(mdadm --detail /dev/md/0 | sed -z 's/\n/\\n/g')

data=`cat <<_EOT_
{
     "embeds": [
        {
            "color": 16711680,
            "title": "MD Array Invalid Status",
            "description": "\\\`${SELF_HOST_NAME}\\\` のソフトウェアRAIDのArrayの状態異常です。",
            "fields": [
                {
                    "name": "Host Name(IP Address)",
                    "value": "${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})",
                    "inline": false
                },
                {
                    "name": "MD Status",
                    "value": "cat /proc/mdadm said... \\\`\\\`\\\`${mdstat}\\\`\\\`\\\` ",
                    "inline": false
                },
                {
                    "name": "mdadm Details",
                    "value": "mdadm --detail said... \\\`\\\`\\\`${mdadm_detail}\\\`\\\`\\\` ",
                    "inline": false
                },
            ],
        }
    ]
}
_EOT_`

./chat_send.sh "${data}" ${CHAT_WEBHOOK_URL}

echo '異常在り。異常終了。'
echo "${0} end   at `date '+%Y/%m/%d %R'`"

exit 1