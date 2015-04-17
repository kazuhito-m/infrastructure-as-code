#
# Cookbook Name:: custom-apache2
# Recipe:: default
#
# Copyright 2015, kccs k-miura
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apache2'

web_app 'myproj' do
  template 'httpd.conf.erb'
end
