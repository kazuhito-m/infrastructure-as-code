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
