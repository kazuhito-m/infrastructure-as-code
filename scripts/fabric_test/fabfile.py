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

def install_msvsc():
	run("wget https://az764295.vo.msecnd.net/public/0.9.1/VSCode-linux64.zip", pty=False)
	run("unzip ./VSCode*.zip", pty=False)
	run("rm ./VSCode*.zip")
	sudo("mv ./VSCode* /usr/local/lib/")
	sudo("ln -s /usr/local/lib/VSCode*/Code /usr/local/bin/VSCode")
	# extends in .vscode/extensions/ , configfile in .config/Code/User
