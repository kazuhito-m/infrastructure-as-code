# VNCで接続した途端ブラウザーが立ち上がった状態となるCentOS6のイメージを作成する。
FROM centos:centos6
MAINTAINER kazuhito miura <@kazuhito_m>

ENV DESKTOP_USER desktopvnc

# パッケージ最新アップデー卜
RUN yum -y update

# Desktop系のパッケージグループインストール
RUN yum -y groupinstall "X Window System" 
RUN yum -y groupinstall "Desktop" 
RUN yum -y groupinstall "General Purpose Desktop"
# sshサーバ
RUN yum -y install openssh-server 
# Browser
RUN yum -y install firefox
# vnc server
RUN yum -y install tigervnc-server
# javaのインストールと、selenium-server-standalone をダウンロード。
RUN yum -y install java-1.7.0-openjdk wget
RUN wget http://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar
RUN mkdir -p /usr/local/bin/selenium/
RUN mv *.jar /usr/local/bin/selenium/
RUN chmod -R 777 /usr/local/bin/selenium

# 日本語化
RUN yum -y groupinstall "Japanese Support"
RUN echo 'LANG="ja_JP.UTF-8"' > /etc/sysconfig/i18n
RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# ユーザ追加
RUN echo 'root:root' | chpasswd
RUN useradd -m ${DESKTOP_USER}
RUN echo "${DESKTOP_USER}:${DESKTOP_USER}" | chpasswd
# ユーザの独自設定として.bashrcを追加。
ADD ./templates/.config /home/${DESKTOP_USER}/.config/
CMD chown -R ${DESKTOP_USER}:${DESKTOP_USER} /home/${DESKTOP_USER}/.config/

# 予め、VNCのパスワード等「vncの静的な情報」を設定しておく。
RUN rm -rf /home/${DESKTOP_USER}/.vnc/
ADD ./templates/.vnc/ /home/${DESKTOP_USER}/.vnc/
RUN chown -R ${DESKTOP_USER}:${DESKTOP_USER} /home/${DESKTOP_USER}/.vnc/

# vncで大量エラーを吐くので、おまじない。
RUN dbus-uuidgen > /var/lib/dbus/machine-id

# 開始時に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]

