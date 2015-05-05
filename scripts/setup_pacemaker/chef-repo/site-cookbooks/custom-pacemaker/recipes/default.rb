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

# corosyncの設定ファイルをリンクで配置。
# 
# Dockerでマウントしたホストディレクトリのファイル corosync.conf を、所定位置にシンボリックリンクを貼る
# ※これを固定出来ないせいで、ホスト側の固定ファイルに頼ることとなり、Docker依存の構造が必須に。
link "/etc/corosync/corosync.conf" do
  to "/chef-repo/site-cookbooks/custom-pacemaker/files/default/corosync.conf"
  action :create
end

# corosyncのサービスを登録＆起動。
service "corosync" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end
