#coding:utf-8
from fabric.api import local, run, sudo, put, env


# 実行前に、以下のじゅんびが　必要です
#
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
	sudo("apt-get install -f -y tree indicator-multiload clipit openssh-server", pty=False)

