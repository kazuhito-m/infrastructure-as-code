#coding:utf-8
from fabric.api import local, run, sudo, put, env


# 実行前に、以下のじゅんびが　必要です
# + 標準のubuntu側にあるsetup_allは流しておくこと
#
def setup_all():
	all_upgrade()
	install_custom_tools()

def install_custom_tools():
	sudo("apt-get install -f -y ", pty=False)

