FROM centos:centos6

MAINTAINER Kazuhito Miura 

# ベースとなる装備(ソース管理とChefなど)インストール
RUN yum update -y

# ここにChefをぶっこむ

# デタッチ毎に実行するスクリプトを登録
ADD ./scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh
CMD ["/usr/local/bin/startup.sh"]

file:///home/kazuhito/git/work/refactoring-samples-by-yuki/work/prod-clone/scripts/startup.sh
file:///home/kazuhito/git/work/refactoring-samples-by-yuki/work/prod-clone/scripts/startup.sh
file:///home/kazuhito/git/work/refactoring-samples-by-yuki/work/prod-clone/scripts/startup.sh
