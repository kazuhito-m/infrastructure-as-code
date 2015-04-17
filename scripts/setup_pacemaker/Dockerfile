FROM centos:centos6.6

MAINTAINER Kazuhito Miura 

# ベースとなる装備(ソース管理とChefなど)インストール
RUN yum update -y
RUN yum groupinstall -y "Development Tools"
RUN yum install -y git svn openssl-devel tar

# Rubyのバージョンが古すぎるということがあったので、諦めて手動インストール
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc ; echo 'eval "$(rbenv init -)"' >> ~/.bashrc ; source ~/.bashrc
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile

# rbenv自体のインストール作業。
RUN ./root/.rbenv/plugins/ruby-build/install.sh
RUN rbenv install 2.2.2 && rbenv global 2.2.2

# Chefと周辺プロダクトをインストール。
RUN echo 'eval "install: --no-document"' >> .gemrc
RUN echo 'eval "update: --no-document"' >> .gemrc
RUN bash -l -c 'gem install chef knife-solo bundler berkshelf --no-ri --no-rdoc -V'

# Chefのレシピを一式持っていく
ENV CHEFHOME /chef-repo
ADD chef-repo /chef-repo
 
# Chefのこのマシン専用レシピの実行。
ENV https_proxy http://proxy.nintendo.co.jp:8080
RUN bash -lc "cd ${CHEFHOME} && berks vendor cookbooks"
RUN bash -lc "chef-solo -c ${CHEFHOME}/solo.rb -j ${CHEFHOME}/nodes/ncms01.json"

# 外側に出したいPortを定義
EXPOSE 21

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]
