#!/usr/bin/perl

# ieServer.Net 専用 DDNS IP アドレス更新スクリプト AWS改造版

# ieServer.Netにて取得したアカウント（サブドメイン）情報を記入
$ACCOUNT         = "";     # アカウント(サブドメイン)名設定
$DOMAIN          = "";     # ドメイン名設定
$PASSWORD        = "";     # パスワード設定

# --------

# 以下２ファイルの配置ディレクトリは好みに応じ設定
# 1. 設定IPアドレスワークファイル
$CURRENT_IP_FILE = "/tmp/current_ip";

#  2. 設定状況ログファイル
$LOG_FILE        = "/var/log/ip_update.log";

# 回線IP確認ページURL
$REMOTE_ADDR_CHK = "http://ieserver.net/ipcheck.shtml";
# DDNS更新ページURL
# wgetをSSL接続可能でビルドしているなら、https:// での接続を推奨
$DDNS_UPDATE     = "http://ieserver.net/cgi-bin/dip.cgi";

if(!open(FILE,"$CURRENT_IP_FILE")) {
    $CURRENT_IP = '0.0.0.0';
    } else {
    $CURRENT_IP = <FILE>;
    close FILE;
}

# $NEW_IP = '0.0.0.0';
$NEW_IP = '';

if ($NEW_IP ne "0.0.0.0" and $CURRENT_IP ne $NEW_IP) {

    $STATUS = `wget -q -O - '$DDNS_UPDATE?username=$ACCOUNT&domain=$DOMAIN&password=$PASSWORD&updatehost=1'`;

    if ($STATUS =~ m/$NEW_IP/) {
        open (FILE ,">$CURRENT_IP_FILE");
        print FILE $NEW_IP;
        close FILE;
        $TIME = localtime;
        open (FILE ,">>$LOG_FILE");
        print FILE "$TIME $ACCOUNT.$DOMAIN Updated $CURRENT_IP to $NEW_IP\n";
        close FILE;
    } else {
        $TIME = localtime;
        open (FILE ,">>$LOG_FILE");
        print FILE "$TIME $ACCOUNT.$DOMAIN Update aborted $CURRENT_IP to $NEW_IP\n";
        close FILE;
    }
}
exit;
