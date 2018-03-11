#!/bin/bash

CLOUDATCOST_STRAGE_USERNAME=""
CLOUDATCOST_STRAGE_PASSWORD=""

function upload_cloudatcost_strage() {

  target_local_file=${1}

  echo "${target_local_file} をアップロードします。"

  curl -o /dev/null --dump-header -  https://download.cloudatcost.com/user/manage-check.php -X POST \
    -d "username=${CLOUDATCOST_STRAGE_USERNAME}" \
    -d "password=${CLOUDATCOST_STRAGE_PASSWORD}&submit=" \
    > ./result.log

  grep 'login.php?error' ./result.log > /dev/null
  if [ $? -eq 0 ] ; then
    echo 'ユーザorパスワードが間違っています。'
    exit 128
  fi

  session_cookie=`grep 'Set-Cookie:' ./result.log | sed -e 's/.*PHPSESSID/PHPSESSID/g' | sed -e 's/; .*//g'`

  curl https://download.cloudatcost.com/upload.php -X POST \
    -H "Cookie: ${session_cookie}" \
    -F "file=@${target_local_file}" \
    > ./result.log

  grep '^1' ./result.log > /dev/null
  if [ $? -ne 0 ] ; then
    echo 'アップロード時にエラーが発生しました。'
    cat ./result.log
    exit 128
  fi

  file_key=`sed 's/^1.//g' ./result.log`
  echo "アップロード成功。 http://download.cloudatcost.com/download/${file_key}"
}

# mongodb でのバックアップ(ツールベース&ファイルベース)
function dump_mongodb() {
  ymdhms=${1}
  # mongodbを「ツールによるエクスポート」でバックアップ。
  mongodb_host=$(docker inspect dockercrowi_mongo_1 | jq -r '.[].NetworkSettings.Networks.dockercrowi_default.IPAddress')
  mongodump --host=${mongodb_host} --gzip --archive=./crowi_mongodump.${ymdhms}.gz
  # mongodbの「ファイルベース」でのバックアップ。
  for i in $(docker inspect dockercrowi_mongo_1 | jq -r '.[].Mounts[] | [.Destination, .Source] | @csv' | sed -e 's/"//g') ; do
    id=$(echo ${i} | cut -f1 -d',' | xargs basename)
    volume_path=$(echo ${i} | cut -f2 -d',')
    # /var/lib/docker/volumes の当該ディレクトリをアーカイブ
    tar czf ./${id}.${ymdhms}.tgz ${volume_path}
  done
}

ymdhms=`date "+%Y%m%d%H%M%S"`
backup_dir=/tmp/container_backup

mkdir -p ${backup_dir}
cd ${backup_dir}

for i in $(docker ps -a --format '{{.Names}}' | grep crowi); do
  backup_name="${i}.${ymdhms}"
  echo "${i} container backup start ..."
  docker commit ${i} ${backup_name}
  docker save -o ${backup_name}.image ${backup_name}
  docker rmi -f ${backup_name}
  echo ${backup_name}
done

archive_file=crowiplus.${ymdhms}.tgz.not.zip
tar cvzf ${archive_file} ./*.image

dump_mongodb ${ymdhms}

upload_cloudatcost_strage ${archive_file}

rm -rf ${backup_dir}

echo 'バックアップが完了しました。'
