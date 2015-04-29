#
# Cookbook Name:: japanize
# Recipe:: default
#
# Copyright (C) 2015 kccs kazuhito miura
# 
# 日本語化、またいろんなモンを「ここ用のサーバ」にしていくレシピ。

# Timezone settings

log("tz-info(before): #{Time.now.strftime("%z %Z")}")

service 'crond'

link '/etc/localtime' do
  to '/usr/share/zoneinfo/Asia/Tokyo'
  notifies :restart, 'service[crond]', :immediately
  only_if {File.exists?('/usr/share/zoneinfo/Asia/Tokyo')}
end

log("tz-info(after): #{Time.now.strftime("%z %Z")}")
