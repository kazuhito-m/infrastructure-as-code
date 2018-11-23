FROM dorowu/ubuntu-desktop-lxde-vnc

MAINTAINER kazuhito miura <@kazuhito_m>

RUN apt-get update && \
    apt-get install -y openssh-client locales && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーン＆ロケール設定。
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

COPY scripts/boot.sh /boot.sh
RUN chmod +x /boot.sh

COPY resources/config.sh /config.sh

COPY resources/ssh_tonnering_key.pem /ssh_tonnering_key.pem
RUN chmod 400 /ssh_tonnering_key.pem

COPY scripts/init_firefox.sh /init_firefox.sh
RUN bash /init_firefox.sh

ENTRYPOINT ["/boot.sh"]
