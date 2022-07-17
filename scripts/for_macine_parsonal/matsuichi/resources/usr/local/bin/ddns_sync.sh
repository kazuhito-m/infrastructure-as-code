#!/bin/bash

# DDNS Now のDDNS情報を現在のリモートホスト情報で更新するスクリプト。
#
# DDNS Now site : https://ddns.kuku.lu/
#

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LOGFILE=/var/log/ddns_sync.log
CONFFILE=/usr/local/etc/ddns_sync.conf.csv

echo "${0} start at `date '+%Y/%m/%d %R'` " >> $LOGFILE

while read row; do
    domain=$(echo ${row} | cut -d , -f 1)
    apiKey=$(echo ${row} | cut -d , -f 2)

    echo -n "ドメイン名:${domain} > RESULT:" >> $LOGFILE
    url="https://f5.si/update.php?domain=${domain}&password=${apiKey}"
    curl -X GET ${url} >> $LOGFILE
    
    echo >> $LOGFILE
done < ${CONFFILE}

echo "${0} end   at `date '+%Y/%m/%d %R'` " >> $LOGFILE

exit 0