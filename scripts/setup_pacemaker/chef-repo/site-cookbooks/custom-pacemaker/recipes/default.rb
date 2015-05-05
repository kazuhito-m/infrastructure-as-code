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

# corosyncの設定をコマンドで放り込む。
bash "" do
  code <<-EOH
    pcs property set stonith-enabled=false
    pcs property set no-quorum-policy=ignore
    pcs resource create vip1 ocf:heartbeat:IPaddr2  nic="eth0" ip=172.17.1.20 cidr_netmask=24 iflabel= op monitor interval=5s
    pcs resource create dgw ocf:heartbeat:Route  destination="0.0.0.0/0" gateway="172.17.1.254" op monitor interval=5s
    pcs resource group add  service1 vip1 dgw
    pcs resource create apache ocf:heartbeat:apache params configfile="/etc/httpd/conf/httpd.conf"  op monitor interval="5s"
    pcs resource clone apache apache-clone
    pcs constraint colocation  add service1 apache-clone
    pcs resource create tomcat6 lsb:tomcat6 op monitor interval="5s"
    pcs resource clone tomcat6 tomcat6-clone
    pcs constraint colocation  add service1 apache-clone tomcat6-clone
    pcs resource create vip2 ocf:heartbeat:IPaddr2  nic="eth0" ip=172.17.1.21 iflabel=1 cidr_netmask=24 op monitor interval=5s
    pcs resource group add service2 vip2
    pcs resource create mysql lsb:mysql  op monitor interval="5s"
    pcs resource clone mysql mysql-clone
    pcs constraint  colocation add service2 mysql-clone
  EOH
end 

