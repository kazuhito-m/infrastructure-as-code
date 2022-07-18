#!/bin/bash

# 
# 週に一度フルバックアップをサブディスクに取得するスクリプト
# 
# - 異常ならSlackに報告する
#
# Premise
#   以下のコマンドを必要とする
#     dump mkdir curl
#

# 定数
SELF_HOST_NAME=$(hostname)
SELF_HOST_DOMAIN_NAME=${SELF_HOST_NAME}.local.miu2.f5.si
SELF_HOST_IP=$(host ${SELF_HOST_DOMAIN_NAME} | sed 's/.*address //g')

BACKUP_DIR='/subarea/backup_home'

# Path調整
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# 自身スクリプトまで移動。
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

# 設定読込
source ../../etc/maintenance/slack.conf

# main part

echo "${0} start at `date '+%Y/%m/%d %R'`"

mkdir -p ${BACKUP_DIR}
rm -f ${BACKUP_DIR}/*.dump.*

dump_file_name="$(hostname)_home_dir_$(date '+%Y%m%d%H%M%S').dump.bz2"
dump_file_path="${BACKUP_DIR}/${dump_file_name}"

# 実行
dump -j -f ${dump_file_path} /home

if [ $? -eq 0 ]; then
    echo '異常無し。正常終了。'
    echo "${0} end   at `date '+%Y/%m/%d %R'`"
    exit 0
fi

## 異常時

df_state=$(df -h)
lsblk_state=$(lsblk)

data=`cat <<_EOT_
{
     "attachments": [
        {
	        "mrkdwn_in": ["text"],
            "color": "danger",
            "title": "/home full backup failed.",
            "pretext": "${SELF_HOST_NAME} の /home のフル・バックアップに失敗しました。",
            "fields": [
                {
                    "title": "Host Name(IP Address)",
                    "value": "${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})",
                    "short": false
                },
                {
                    "title": "Disk status",
                    "value": "df -h said... \\\`\\\`\\\`${df_state}\\\`\\\`\\\` ",
                    "short": false
                },
                {
                    "title": "Block Device status",
                    "value": "lsblk said... \\\`\\\`\\\`${lsblk_state}\\\`\\\`\\\` ",
                    "short": false
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
