FROM postgres:9.6

MAINTAINER kazuhito_m

RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
COPY init_sql/*.sql /docker-entrypoint-initdb.d/
