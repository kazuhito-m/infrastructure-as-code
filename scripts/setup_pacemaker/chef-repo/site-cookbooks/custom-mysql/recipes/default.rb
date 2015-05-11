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
