FROM centos:centos6.6

MAINTAINER Kazuhito Miura

# ベースとなる装備(ソース管理とChefなど)インストール
RUN yum update -y
RUN yum groupinstall -y "Development Tools"
RUN yum install -y git openssl-devel tar

# Rubyのバージョンが古すぎるということがあったので、諦めて手動インストール
ENV BASE /root
ENV RBENV_ROOT ${BASE}/.rbenv
ENV PATH ${RBENV_ROOT}/bin:$PATH
RUN git clone https://github.com/sstephenson/rbenv.git ${RBENV_ROOT}
RUN git clone https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build
RUN echo "export RBENV_ROOT=${RBENV_ROOT}"  >> $BASE/.bashrc
RUN echo 'export PATH="${RBENV_ROOT}/bin:$PATH"' >> $BASE/.bashrc 
RUN echo 'eval "$(rbenv init -)"' >> $BASE/.bashrc

# rbenv自体のインストール作業。
ENV RUBY_VER 2.2.2
RUN source ${BASE}/.bashrc && ${RBENV_ROOT}/plugins/ruby-build/install.sh && rbenv install ${RUBY_VER} && rbenv global ${RUBY_VER}

# Chefと周辺プロダクトをインストール。
RUN echo 'eval "install: --no-document"' >> ${BASE}/.gemrc
RUN echo 'eval "update: --no-document"'  >> ${BASE}/.gemrc
RUN bash -lc "source ${BASE}/.bashrc && gem install chef knife-solo bundler berkshelf --no-ri --no-rdoc -V"

# Chefのレシピを一式持っていく
ENV CHEFHOME /chef-repo
ADD chef-repo ${CHEFHOME}
 
# Chefのこのマシン専用レシピの実行。
RUN bash -lc "source ${BASE}/.bashrc && cd ${CHEFHOME} && berks vendor cookbooks"
RUN bash -lc "source ${BASE}/.bashrc && chef-solo -c ${CHEFHOME}/solo.rb -j ${CHEFHOME}/nodes/pm01.json"

# 外側に出したいPortを定義
# EXPOSE 21

# 暫定対応。Rootのパスワード固定
# TODO Chefに移して葬る
RUN yum install -y openssh-server
RUN echo 'root:root' | chpasswd
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN service sshd restart

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]

