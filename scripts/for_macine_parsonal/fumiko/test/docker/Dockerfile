FROM debian:bullseye

# インストール
RUN apt-get update ; apt-get upgrade -y
# 基本的なソフトは予め入れる
RUN apt-get install -y curl wget vim byobu task-japanese openssh-server

# Timezone/locale 設定
RUN echo 'LANG="ja_JP.UTF-8"' > /etc/default/locale
RUN cat /usr/share/zoneinfo/Asia/Tokyo > /etc/localtime

# ssh サーバ 設定
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 一般ユーザ追加。
RUN useradd -m kazuhito
RUN echo 'kazuhito:kazuhito' | chpasswd

# デタッチ毎に実行するスクリプトを登録
ENTRYPOINT service ssh restart && tail -f /dev/null
