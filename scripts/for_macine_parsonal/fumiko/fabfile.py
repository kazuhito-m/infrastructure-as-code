#coding:utf-8
from fabric.api import local, run, sudo, put, env

# KURO-NAS/X4の跡地に入れた「普通のPC」fumikoのAsCodeしたものです。
#
# 実行前の準備は、manual_operation.md 参照。

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
	sudo("apt-get install -f -y tree byobu", pty=False)
