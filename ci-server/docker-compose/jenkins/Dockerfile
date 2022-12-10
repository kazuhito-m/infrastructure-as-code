FROM jenkins/jenkins:lts

USER root

# createrepo は「Jenkins内で親のrpmリポジトリを作る」ため
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install locales software-properties-common apt-transport-https ca-certificates gnupg2 lsb-release createrepo \
    file postgresql-client host nodejs -y && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install docker-ce -y && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーン＆ロケール設定。
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
# 上の /etc/localtime だけでは不完全なので
RUN echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
# 上のlocale-genで作られるはずだが、うまく行かないので
RUN echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

# FIXME 一般ユーザから"dockerコマンドが叩けるようにgroupに足している"が動かない。暫定策でsuidを立てる。できれば解消したい。
RUN chmod u+s $(which docker) && \
    gpasswd -a jenkins docker && \
    usermod -aG sudo jenkins && \
    echo 'jenkins ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER jenkins

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh", "--prefix=/ci"] # context root をずらす
