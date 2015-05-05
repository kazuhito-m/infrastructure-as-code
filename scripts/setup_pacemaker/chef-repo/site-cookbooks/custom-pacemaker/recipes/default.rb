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

# 設定などをする前に、Pacemakerの起動スクリプトにバグっぽいのがあるので、それを治す。
bash "pacmaker start script fix" do
  code <<-EOH
    cat /etc/init.d/pacemaker | sed 's/status()/status_pm()/g' | sed 's/status \\$/status_pm \\$/g' > /etc/init.d/pacemaker.conv
    diff /etc/init.d/pacemaker /etc/init.d/pacemaker.conf > /dev/null
    res=$?
    if [[ $res -eq 0 ]] ; then
      rm /etc/init.d/pacemaker.conv
    else
      mv /etc/init.d/pacemaker /etc/init.d/pacemaker.org
      mv /etc/init.d/pacemaker.conv /etc/init.d/pacemaker
      chmod 755 /etc/init.d/pacemaker
    fi
  EOH
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

# Pacemakerサービス登録&起動
service "pacemaker" do
  action [ :enable, :start ]
  supports :status => true, :restart => true, :reload => true
end


# Paceakerの設定をコマンドで放り込む。
bash "Pacemaker setting add" do
  code <<-EOH
    pcs property set stonith-enabled=false
    pcs property set no-quorum-policy=ignore
    pcs status | grep 'Group: service1' > /dev/null
    if [[ $? -ne 0 ]] ; then
      pcs resource create vip1 ocf:heartbeat:IPaddr2  nic="eth0" ip=172.17.1.20 cidr_netmask=24 iflabel= op monitor interval=5s
      pcs resource create dgw ocf:heartbeat:Route  destination="0.0.0.0/0" gateway="172.17.1.254" op monitor interval=5s
      pcs resource group add  service1 vip1 dgw
      pcs resource create apache ocf:heartbeat:apache params configfile="/etc/httpd/conf/httpd.conf"  op monitor interval="5s"
      pcs resource clone apache apache-clone
      pcs constraint colocation  add service1 apache-clone
      pcs resource create tomcat6 lsb:tomcat6 op monitor interval="5s"
      pcs resource clone tomcat6 tomcat6-clone
      pcs constraint colocation  add service1 apache-clone tomcat6-clone
    fi
    pcs status | grep 'Group: service2' > /dev/null
    if [[ $? -ne 0 ]] ; then
      pcs resource create vip2 ocf:heartbeat:IPaddr2  nic="eth0" ip=172.17.1.21 iflabel=1 cidr_netmask=24 op monitor interval=5s
      pcs resource group add service2 vip2
      pcs resource create mysql lsb:mysql  op monitor interval="5s"
      pcs resource clone mysql mysql-clone
      pcs constraint  colocation add service2 mysql-clone
    fi
  EOH
end 

