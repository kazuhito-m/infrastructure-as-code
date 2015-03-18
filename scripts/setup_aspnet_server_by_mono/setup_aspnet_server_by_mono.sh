#!/bin/bash

# CentOS 6.5 上で ASP.NET MVC(Ver.3) 相当のサーバを稼働させるためのスクリプト。
# see also http://www.atmarkit.co.jp/ait/articles/1303/15/news069.html
# 稼働確認は Vagrant上のCeonOS6.5のみ。
# なお、実行には数時間かかるのでそのつもりで…。


# locate and timezone 設定
rm -f /etc/localtime
cp -p /usr/share/zoneinfo/Japan /etc/localtime

yum groupinstall "Japanese Support"
localedef -f UTF-8 -i ja_JP ja_JP.utf8

mv /etc/sysconfig/i18n /etc/sysconfig/i18n.org
sed 's/en_US/ja_JP/g' /etc/sysconfig/i18n.org > /etc/sysconfig/i18n


# 必要なツールをインストール
yum -y install gcc-c++.x86_64 glib2-devel.x86_64 cairo-devel.x86_64 libpng-devel.x86_64 giflib-devel.x86_64 libjpeg-devel.x86_64 libtiff-devel.x86_64 libexif-devel.x86_64 httpd-devel.x86_64 bison.x86_64 gettext.x86_64 wget libjpeg-devel


# ビルド必要ソース一式取得＆展開
cd /usr/local/src
wget http://download.mono-project.com/sources/libgdiplus/libgdiplus-2.10.9.tar.bz2
wget http://download.mono-project.com/sources/mono/mono-2.10.9.tar.bz2
wget http://download.mono-project.com/sources/mod_mono/mod_mono-2.10.tar.bz2
wget http://download.mono-project.com/sources/xsp/xsp-2.10.2.tar.bz2
tar xjf libgdiplus-2.10.9.tar.bz2
tar xjf mono-2.10.9.tar.bz2
tar xjf mod_mono-2.10.tar.bz2
tar xjf xsp-2.10.2.tar.bz2


# 順次必要なモジュールのビルド

# libgdipplus 
cd /usr/local/src/libgdiplus-2.10.9
./configure
make
make install

# mono
cd /usr/local/src/mono-2.10.9
./configure --with-libgdiplus=/usr/local/lib/libgdiplus.la
make
make install

# xsp (aprication server)
cd /usr/local/src/xsp-2.10.2 
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin 
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure
make
make install

# mod_mono (apache module)
cd /usr/local/src/mod_mono-2.10
./configure
make
make install

# http.conf 編集

cd /etc/httpd/conf/
cp httpd.conf httpd.conf.backup

cat << _EOT_ >> ./httpd.conf

# mono for cgi setting file include.

Include conf/mod_mono.conf

# mono asp.net vmc settings.

MonoAutoApplication disabled
MonoServerPath "/usr/local/bin/mod-mono-server4"
MonoApplications default "/sampleapp:/var/www/sampleapp"
<Location /sampleapp >
  SetHandler mono
  MonoSetServerAlias default
</Location>
_EOT_

# sample application Download and unzip
cd /var/www/
wget http://www.ginger-inc.jp/samples/sampleapp.zip
unzip sampleapp.zip

/etc/init.d/httpd restart


# 後は、 http://[server ip]/sampleapp/ をブラウザで開き、挙動を確認するばかり。
