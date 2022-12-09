#coding:utf-8
from fabric.api import local, run, sudo, put, env


# 実行前に、以下のじゅんびが　必要です
# + 標準のubuntu側にあるsetup_allは流しておくこと
#
def setup_all():
    all_upgrade()
    install_custom_tools()
    set_static_ip()
    install_rescure_tools()

def install_custom_tools():
	sudo("apt-get install -f -y openssh-server", pty=False)

def set_static_ip():
	# DNS設定を中央集権に
	sudo("apt-get install -f -y resolvconf", pty=False)
	# IP固定設定。
	# FIXME いろいろと決め打ちで書いてある。特に接続は"有線接続 1"という名前に固定してあるので、抽象化していきたい。
	sudo("nmcli connection modify '有線接続 1' ipv4.method manual ipv4.addresses 192.168.1.130/24 ipv4.gateway 192.168.1.1 ipv4.dns 192.168.1.5 ipv4.dns-search local.miu2.f5.si") 


def install_viratual_macine_environment():
	sudo("apt-get install -f -y virtualbox", pty=False)

def install_rescure_tools()
	sudo("apt-get install -f -y testdisk foremost", pty=False)
	
