#!/bin/bash

# 
# 週に一度フルバックアップをサブディスクに取得するスクリプト
# 
# - 異常ならチャットに報告する
#
# Premise
#   以下のコマンドを必要とする
#     dump mkdir curl
#
# 経緯
# - 当初、 -y や -j での圧縮を試していたが「微々たるもの」「100時間くらいかかる」となったので無圧縮に落ち着いた。
#

# 定数
SELF_HOST_NAME=$(hostname)
SELF_HOST_DOMAIN_NAME=$(domainname -A | cut -d' ' -f1)
SELF_HOST_IP=$(host ${SELF_HOST_DOMAIN_NAME} | sed 's/.*address //g')

BACKUP_DIR='/subarea/backup_home'

# Path調整
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# 自身スクリプトまで移動。
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

# 設定読込
source ../../etc/maintenance/chat.conf

# main part

echo "${0} start at `date '+%Y/%m/%d %R'`"

mkdir -p ${BACKUP_DIR}
rm -f ${BACKUP_DIR}/*.dump*

dump_file_name="$(hostname)_home_dir_$(date '+%Y%m%d%H%M%S').dump"
dump_file_path="${BACKUP_DIR}/${dump_file_name}"

# 実行
time dump -q -y -f ${dump_file_path} /home

if [ $? -eq 0 ]; then
    echo '異常無し。正常終了。'
    echo "${0} end   at `date '+%Y/%m/%d %R'`"
    exit 0
fi

## 異常時

df_state=$(df -h | sed -z 's/\n/\\n/g')
lsblk_state=$(lsblk | sed -z 's/\n/\\n/g')

data=`cat <<_EOT_
{
     "embeds": [
        {
            "color": 16711680,
            "title": "/home full backup failed.",
            "description": "\\\`${SELF_HOST_NAME}\\\` の /home のフル・バックアップに失敗しました。",
            "fields": [
                {
                    "name": "Host Name(IP Address)",
                    "value": "\\\`${SELF_HOST_DOMAIN_NAME}(${SELF_HOST_IP})\\\`",
                    "inline": false
                },
                {
                    "name": "Disk Status",
                    "value": "df -h said... \\\`\\\`\\\`${df_state}\\\`\\\`\\\` ",
                    "inline": false
                },
                {
                    "name": "Block Device Status",
                    "value": "lsblk said... \\\`\\\`\\\`${lsblk_state}\\\`\\\`\\\` ",
                    "inline": false
                }
            ]
        }
    ]
}
_EOT_`

./chat_send.sh "${data}" ${CHAT_WEBHOOK_URL}

echo '異常在り。異常終了。'
echo "${0} end   at `date '+%Y/%m/%d %R'`"

exit 1