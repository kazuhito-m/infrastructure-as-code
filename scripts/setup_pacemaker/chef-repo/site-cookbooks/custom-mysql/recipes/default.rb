#
# Cookbook Name:: custom-mysql
# Recipe:: default
#
# Copyright 2015, kazuhito_n
#
# All rights reserved - Do Not Redistribute
#

%w{mysql mysql-server}.each do |pkg|
  package pkg do
    action :install
  end 
end 

template "my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
end

# ファイルを一時的に設定追加。
bash "my.cnf setting templary change" do
  code <<-EOH
     sed 's/\\[mysqld\]/\\[mysqld\\]\\nskip-grant-tables/g' /etc/my.cnf > /etc/my.cnf.conv
     mv /etc/my.cnf.conv /etc/my.cnf
  EOH
end

service "mysqld" do 
  action [:enable, :restart]
end

# pluginテーブルやら「最初に必要なテーブル郡」を作るため、mysql付属の特殊コマンドを使う。
bash "mysql upgrade" do
  user "mysql"
  group "mysql"
  code "mysql_upgrade --force"
end

# 一時的に変えていた設定を削除し、再度起動。
bash "restart mysqld by normal mode" do
  code <<-EOH
    cat /etc/my.cnf | sed 's/skip-grant-tables//g' > /etc/my.cnf.conv
    diff /etc/my.cnf /etc/my.cnf.conv > /dev/null
    res=$?
    if [[ $res -eq 0 ]] ; then
      rm /etc/my.cnf.conv
    else
      mv /etc/my.cnf.conv /etc/my.cnf
      chmod 755 /etc/my.cnf
      service mysqld restart
    fi
  EOH
end

