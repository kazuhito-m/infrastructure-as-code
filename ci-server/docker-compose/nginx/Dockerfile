FROM nginx:latest

RUN apt-get update && \
    apt-get install certbot cron -y && \
    update-rc.d cron enable && \
    apt-get autoremove -y && \
    apt-get clean -y

ADD ./resources /etc/nginx/conf.d/

ADD ./scripts/startup.sh /usr/local/bin/

ADD ./scripts/renew_letsencrypt /etc/cron.monthly/

RUN chmod 755 /usr/local/bin/startup.sh /etc/cron.monthly/renew_letsencrypt

CMD ["/usr/local/bin/startup.sh"]
