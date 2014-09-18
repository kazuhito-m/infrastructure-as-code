# VNCで接続した途端ブラウザーが立ち上がった状態となるCentOS6のイメージを作成する。
FROM centos:centos6
MAINTAINER kazuhito miura <@kazuhito_m>

# ENV DEBIAN_FRONTEND noninteractive
# ENV HOME /root

# パッケージ最新アップデー卜
RUN yum -y update

# Desktop系のパッケージグループインストール
RUN yum -y groupinstall "X Window System" 
RUN yum -y groupinstall "Desktop" 
RUN yum -y groupinstall "General Purpose Desktop"
# vnc server
RUN yum -y install tigervnc-server

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856

# RUN apt-mark hold initscripts udev plymouth mountall
# RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl
# 
# RUN apt-get update \
#     && apt-get install -y --force-yes --no-install-recommends supervisor \
#         openssh-server pwgen sudo vim-tiny \
#         net-tools \
#         lxde x11vnc xvfb \
#         gtk2-engines-murrine ttf-ubuntu-font-family \
#         nodejs \
#         libreoffice firefox \
#     && apt-get autoclean \
#     && apt-get autoremove \
#     && rm -rf /var/lib/apt/lists/*
# 
# ADD noVNC /noVNC/
# 
# ADD startup.sh /
# ADD supervisord.conf /
# EXPOSE 6080
# EXPOSE 5900
# EXPOSE 22
# WORKDIR /
# ENTRYPOINT ["/startup.sh"]
