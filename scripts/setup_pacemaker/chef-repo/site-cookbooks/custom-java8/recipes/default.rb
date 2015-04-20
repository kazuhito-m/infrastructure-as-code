# Cookbook Name:: custum-java8
# Recipe:: default
#
# Java8のインストールが公式のレシピでできなかった(Oracleのやつだけという限定ぶり)ので、
# 自力かつパッケージ指定で無理やりインストールする。

# 状況を再現するため「７入れて８入れる」とする。
%w{java-1.7.0-openjdk java-1.8.0-openjdk}.each do |pkg|
  package pkg do
    action :install
  end
end

# (Cent/RHEL限定で)aliternatives叩いてJava8に固定
bash "set jave version for openjdk" do
  code "rm -rf /etc/alternatives/java && ln -s /usr/lib/jvm/java-1.8.0-openjdk*/jre/bin/java /etc/alternatives/java"
  not_if "java -version 2>&1 | grep '1.8'"
end 	

