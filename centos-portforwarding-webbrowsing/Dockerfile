FROM dorowu/ubuntu-desktop-lxde-vnc

MAINTAINER kazuhito miura <@kazuhito_m>

COPY scripts/boot.sh /boot.sh
RUN chmod +x /boot.sh

ENTRYPOINT ["/boot.sh"]
