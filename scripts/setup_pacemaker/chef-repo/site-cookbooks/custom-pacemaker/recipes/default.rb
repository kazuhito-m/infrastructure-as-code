#
# Cookbook Name:: custom-pacemaker
# Recipe:: default
#
# Copyright 2015, kazuhito_m
#
# All rights reserved - Do Not Redistribute
#

# Failout できる装備３つのセットをインストールする。
%w{pacemaker pcs corosync}.each do |pkg|
  package pkg do
    action :install
  end
end

# 設定ファイルをコピー
cookbook_file "/etc/corosync/service.d/pcmk" do
  mode 00644
end

# 前提として、syslogが動いていること。
service "rsyslog" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end

# corosyncのサービスを登録＆起動。
# service "corosync" do
#   action [ :enable, :start ]
#   supports :status => true, :restart => true, :reload => true
# end
