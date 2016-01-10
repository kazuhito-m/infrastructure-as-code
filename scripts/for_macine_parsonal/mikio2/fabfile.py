#coding:utf-8
from fabric.api import local, run, sudo, put, env

SELF_MAIL_ADDRESS = "test@gmail.com"
USER_NAME = "kazuhito-m"
GIT_PASS = "xxxx"

# 実行前に、以下のじゅんびが　必要です
#
# 上部の定数を個人設定の本当の値に置き換える
# ./resource/.dropbox_uploader に値をいれたものを配置する
#
def setup_all():
	all_upgrade()
	install_common_tools()

def all_upgrade():
	sudo("apt-get update", pty=False)
	# sudo("do-release-upgrade -d", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get upgrade -y", pty=False)
	sudo("apt-get dist-upgrade -y", pty=False)

def install_common_tools():
	sudo("apt-get install -f -y tree indicator-multiload clipit", pty=False)

