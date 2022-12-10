FROM postgres:11.1-alpine

# タイムゾーン＆ロケール設定。
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV TZ Asia/Tokyo

COPY init_sql/*.sql /docker-entrypoint-initdb.d/

# 多段ファイルシステム対応。(仮想機の上で別ファイルシステムがある場合、ファイル権限がおかしくなり読めなく成る場合があるため)
RUN chmod 777 /docker-entrypoint-initdb.d/*

# crond を動かすため「postgresのdockerイメージ側が最初から用意してるスクリプト」の最初(シェバンの直後)を書き換え。
RUN sed -e 's/#\!\/usr.*/#\!\/usr\/bin\/env bash\nsu -c "crond -b -l 8"/g' /usr/local/bin/docker-entrypoint.sh > /usr/local/bin/docker-entrypoint.sh.edit && \
    mv /usr/local/bin/docker-entrypoint.sh.edit /usr/local/bin/docker-entrypoint.sh && \
    chmod 775 /usr/local/bin/docker-entrypoint.sh

# 定期的に「DB内容をホストOS側に書き込む」スクリプトを設置
# COPY scripts/export_sonarqube_db_weekly /etc/periodic/weekly/export_sonarqube_db_weekly
# RUN chmod 775 /etc/periodic/weekly/export_sonarqube_db_weekly
