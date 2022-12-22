#
# Cookbook Name:: custom
# Recipe:: default
#
# Copyright 2015, kazuhito_m
#
# All rights reserved - Do Not Redistribute
#

# 必要なパッケージをインストール
%w{ build-essential libusb-dev}.each do |pkg|
  package pkg do
    action :install
  end 
end 

# ※出来ればCentOSとUbuntu両方行けるようにする

# hub-cntlのコンパイル
# hub-ctrlを使うスクリプトの設定
# jenkins のセットアップ
# 回すjobの設定

# aplay的な何か
# OpenTalkセットアップ
# Jenkinsジョブに仕込む

# --- 時間があれば系 ---

# ネットワーク固定設定
# 無線ラン設定

