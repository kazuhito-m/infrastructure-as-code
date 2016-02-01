#coding:utf-8
from fabric.api import local, run, sudo, put, env

# KURO-NAS/X4の跡地に入れた「普通のPC」fumikoのAsCodeしたものです。
#
# 実行前の準備は、manual_operation.md 参照。

# constant

ETH_FILE="/etc/network/interfaces"

# full execute func.

def setup_all():
	all_upgrade()
	install_common_tools()
	setup_network_settings():

# small tasks

def all_upgrade():
	sudo("apt-get update", pty=False)
	# sudo("do-release-upgrade -d", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get upgrade -y", pty=False)
	sudo("apt-get dist-upgrade -y", pty=False)

def install_common_tools():
	sudo("apt-get install -f -y tree byobu", pty=False)

def setup_network_settings():
	TMP_PATH = '/tmp/interfaces'
	backup_by_timestamp(ETH_FILE)
	put("./resources/" + ETH_FILE , TMP_PATH)
	sudo("cp %s %s" % (TMP_PATH,ETH_FILE))
	sudo("ifdown eth0 && ifup eth0")


# TODO

# CPUスピード

# common function

# ファイルを「末尾に年月日時分秒な名称」をつけてコピーする
def backup_by_timestamp(filepath):
	# おそらく設定ファイル系が多いと思うのでrootでやる。
	sudo('cp ' + filepath + ' ' + filepath + '.`date +%Y%m%d%H%M%S`')	

