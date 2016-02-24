#coding:utf-8
from fabric.api import local, run, sudo, put, env

# KURO-NAS/X4の跡地に入れた「普通のPC」fumikoのAsCodeしたものです。
#
# 実行前の準備は、manual_operation.md 参照。

# constant

TMP_PATH = '/tmp/somefile.tmp'
ETH_FILE="/etc/network/interfaces"
NTP_FILE="/etc/ntp.conf"
CPUSPEED_FILE="/etc/sysconfig/cpuspeed"

# full execute func.

def setup_all():
	all_upgrade()
	install_common_tools()
	setup_network_settings()
	setup_ntp_settings()
	setup_md_raid0()

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
	# eth0を設定したinterfaceファイルをサーバに放り込む
	upload_file_with_backup(ETH_FILE)
	# 設定を終えたのでネットワーク再起動
	sudo("ifdown eth0 && ifup eth0")

def setup_ntp_settings():
	sudo("apt-get install -f -y ntp", pty=False)
	# ntp.conf差し替え
	upload_file_with_backup(NTP_FILE)
	# 再起動＆登録
	sudo("systemctl enable ntp")
	sudo("systemctl restart ntp")
	# 登録されてるか確認(参考)
	run("ntpq -p")

def setup_cpuspeed():
	# sudo("apt-get install -f -y cpuspeed", pty=False)
	# upload_file_with_backup(CPUSPEED_FILE)
	# sudo("systemctl enable cpuspeed")
	# sudo("systemctl restart cpuspeed")
	# FIXME 勘違いをしていた。DebianにはCPUSpeedは存在しない。
	# FIXME 改めて調べて作りなおす。
	# FIXME ※初めからONになってるから問題ないという話しもあり、裏とり要

def setup_md_raid0():
	# TODO Raid0をドライブ決め打ちで設定するスクリプトを組もう

	# 先ずはURLのスクラップ
	# http://www.obenri.com/_raid_create/create_mdadm.html
	# http://nabe.blog.abk.nu/0301


# TODO

# common function

# ファイルを「末尾に年月日時分秒な名称」をつけてコピーする
def backup_by_timestamp(filepath):
	# おそらく設定ファイル系が多いと思うのでrootでやる。
	sudo('cp ' + filepath + ' ' + filepath + '.`date +%Y%m%d%H%M%S`')	

# ./resources にあるディレクトリ構成のファイルを、サーバに送り込んだ上置き換える。
# その際、バックアップとして日付ファイルを横に作る。
def upload_file_with_backup(local_file_path):
	backup_by_timestamp(local_file_path)
	put("./resources" + local_file_path , TMP_PATH)
	sudo("cp %s %s" % (TMP_PATH,local_file_path))

