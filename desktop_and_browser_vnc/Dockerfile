# VNCで接続した途端ブラウザーが立ち上がった状態となるCentOS6のイメージを作成する。
FROM centos:centos6
MAINTAINER kazuhito miura <@kazuhito_m>

# ENV DEBIAN_FRONTEND noninteractive
# ENV HOME /root
ENV DESKTOP_USER desktopvnc


# パッケージ最新アップデー卜
RUN yum -y update

# Desktop系のパッケージグループインストール
RUN yum -y groupinstall "X Window System" 
RUN yum -y groupinstall "Desktop" 
RUN yum -y groupinstall "General Purpose Desktop"
# Browser
RUN yum -y install firefox
# vnc server
RUN yum -y install tigervnc-server

# TODO
# 日本語化
RUN yum -y groupinstall "Japanese Support"
RUN echo 'LANG="ja_JP.UTF-8"' > /etc/sysconfig/i18n

# ユーザ追加
RUN useradd -m ${DESKTOP_USER}
# ユーザの独自設定として.bashrcを追加。
ADD ./templates/.bashrc /home/${DESKTOP_USER}/.bashrc
# javaのインストールと、selenium-server-standalone をダウンロード。
RUN yum -y install java-1.7.0-openjdk wget
RUN wget http://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar
RUN mkdir -p /usr/local/bin/selenium/
RUN mv *.jar /usr/local/bin/selenium/
RUN chmod 755 /usr/local/bin/selenium/*.jar

# 予め、VNCのパスワード等「vncの静的な情報」を設定しておく。
RUN rm -rf /home/${DESKTOP_USER}/.vnc/
ADD ./templates/.vnc/ /home/${DESKTOP_USER}/.vnc/
RUN chown -R ${DESKTOP_USER}:${DESKTOP_USER} /home/${DESKTOP_USER}/.vnc/


# JenkinsでSelenium操ってみる実験。
# ancy-vncをUbuntu側に入れてみる
# VNCで入ってみる
# GuestOS側にansy-vncをいれてみて動かしてみる
# Jenkinsに「テスト実行を指示する」技を書いてみる


# ENTRYPOINT ["/startup.sh"]
# 開始時に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]

