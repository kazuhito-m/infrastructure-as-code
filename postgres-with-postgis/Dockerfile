# Official image "Postgres" + PostGIS implementation by dillon.
# See "https://github.com/appropriate/docker-postgis/blob/master/9.5-2.3/Dockerfile" if you can not trust.
FROM mdillon/postgis:9.5

MAINTAINER kazuhito_m

# locale settings.
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# db intial sql's copy.
COPY init_sql/*.sql /docker-entrypoint-initdb.d/
