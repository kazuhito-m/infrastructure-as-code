#coding:utf-8
from fabric.api import local, run, sudo, put, env


# 実行前に、以下の準備が　必要です
# + 標準のubuntu側にあるsetup_allは流しておくこと
#
def setup_all():
    install_custom_tools()
    set_static_ip()
    install_display_driver()

def install_custom_tools():
	sudo("apt-get install -f -y openssh-server", pty=False)

def set_static_ip():
	# DNS設定を中央集権に
	sudo("apt-get install -f -y resolvconf", pty=False)
	# IP固定設定。
	# FIXME いろいろと決め打ちで書いてある。特に接続は"有線接続 1"という名前に固定してあるので、抽象化していきたい。
	sudo("nmcli connection modify '有線接続 1' ipv4.method manual ipv4.addresses 192.168.1.133/24 ipv4.gateway 192.168.1.1 ipv4.dns 192.168.1.5 ipv4.dns-search local.sumpic.orz.hm")
        # DNS設定
        sudo("echo 'nameserver 192.168.1.5' > /etc/resolvconf/resolv.conf.d/base")

def install_display_driver():
	run("curl http://us.download.nvidia.com/XFree86/Linux-x86_64/375.10/NVIDIA-Linux-x86_64-375.10.run > /tmp/NVIDIA.run")
	run("chmod 755 /tmp/NVIDIA.run")
	sudo("service lightdm stop")
	sudo("/tmp/NVIDIA.run")
	sudo("service lightdm start")
