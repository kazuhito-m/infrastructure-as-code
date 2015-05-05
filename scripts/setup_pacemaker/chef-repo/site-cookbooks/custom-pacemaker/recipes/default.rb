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

