#
# Cookbook Name:: user-customize
# Recipe:: default
#
# Copyright 2015, Kazuhito Miura
#

# コンソールやGUIの「ユーザのカスタマイズ要素」に関するパッケージインストールをここにまとめます。
%w{byobu w3m}.each do |pkg|
  package pkg do
    action :install
  end
end

