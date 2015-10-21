from fabric.api import local, run, sudo

def hello():

	# remote
	run("uname -a")
	sudo("head -n 5 /etc/sudoers")

	# local
	local("echo 'Hello World'")

def japanize():
	# change locale
	sudo("apt-get install -y language-pack-ja", pty=False)
	sudo("update-locale LANG=ja_JP.UTF-8")
	# change timezone
	sudo("mv /etc/localtime{,.org}")
	sudo("ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime")

def all_upgrade():
	sudo("apt-get update", pty=False)
#	sudo("do-release-upgrade", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get upgrade -y", pty=False)
	sudo("apt-get dist-upgrade -y", pty=False)

def rename_home_template_dirs():
	run("LC_ALL=C xdg-user-dirs-update --force")
	run("find ~/ -maxdepth 1 -type d  | LANG=C grep  -v '^[[:cntrl:][:print:]]*$' | xargs rm -rf")

