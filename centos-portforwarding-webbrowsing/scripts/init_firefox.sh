#!/bin/bash -x

# 設定インポート
. /config.sh

FIREFOX_SETTING_DIR=/root/.mozilla/firefox
PROFILE_DIR=self.default

# rootユーザのプロファイルのフォルダを作成。
mkdir -p ${FIREFOX_SETTING_DIR}/${PROFILE_DIR}

cat << EOS > ${FIREFOX_SETTING_DIR}/profiles.ini
[General]
StartWithLastProfile=1

[Profile0]
Name=default
IsRelative=1
Path=${PROFILE_DIR}
Default=1
EOS

cat << EOS > ${FIREFOX_SETTING_DIR}/${PROFILE_DIR}/prefs.js
user_pref("network.proxy.socks", "localhost");
user_pref("network.proxy.socks_port", ${SSH_PROXY_PORT});
user_pref("network.proxy.type", 1);
user_pref("browser.startup.homepage", "${BROWSER_DEFAULT_URL}");
// 「初回"Syncしてください"ページ表示」を抑止するため、buildIDとVersion番号を入れておく。(実際のものとずれるかもしれない)
user_pref("browser.startup.homepage_override.buildID", "20181116154524");
user_pref("browser.startup.homepage_override.mstone", "63.0.3");
EOS
