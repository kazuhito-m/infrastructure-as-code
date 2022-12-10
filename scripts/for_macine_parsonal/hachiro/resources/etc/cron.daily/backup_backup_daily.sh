#!/bin/sh -xd
#
# GROWIのWikiデータをバックアップを行うスクリプト。
#

TARGET_DIR=/var/lib/growi
BACKUP_DIR=/dev/nfs/fumiko/Backup/site/growi-miura/in-server-data
TMP_DIR=/var/tmp

BACKUP_FILE_MAX=400

# main.

echo "$(date '+%Y/%m/%d %H:%M:%S') バックアップを開始します。"

file_name="backup_growi_$(date '+%Y%m%d%H%M%S').tgz"
backup_file_path=${BACKUP_DIR}/${file_name}
tmp_file_path=${TMP_DIR}/${file_name}

# 一応、無い可能性を考えてディレクトリ作成。
mkdir -p ${BACKUP_DIR}

echo "archive中... ${tmp_file_path}"
tar czf ${tmp_file_path} ${TARGET_DIR}

echo "ファイル転送中..."
mv ${tmp_file_path} ${backup_file_path}

echo "古いデータの削除中(ローテート)..."
cd ${BACKUP_DIR}
file_count=$(find . -type f | wc -l)
excess_count=$(expr ${file_count} - ${BACKUP_FILE_MAX})
if [ ${excess_count} -gt 0 ]; then
  ls -trF | grep -v '/' | head -n ${excess_count} | xargs rm
fi

echo "$(date '+%Y/%m/%d %H:%M:%S') バックアップが完了しました。"
