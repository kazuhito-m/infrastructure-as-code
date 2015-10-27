#coding:utf-8
from fabric.api import local, run, sudo

SELF_MAIL_ADDRESS = "sumpic@hotmail.com"
USER_NAME = "kazuhito-m"
GIT_PASS = "xxxx"

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
	# サイトから落としてくるベースで考えたが、umakeとVSCパッケージ対応があったので、それで対応。
#	run("wget https://az764295.vo.msecnd.net/public/0.9.1/VSCode-linux64.zip", pty=False)
#	run("unzip ./VSCode*.zip", pty=False)
#	run("rm ./VSCode*.zip")
#	sudo("mv ./VSCode* /usr/local/lib/")
#	sudo("ln -s /usr/local/lib/VSCode*/Code /usr/local/bin/VSCode")
	sudo("add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make")
	sudo("apt-get update -y")
	sudo("apt-get install -y ubuntu-make")
	run("umake -v web visual-studio-code")
	# ここだけは、対話型で打たねばならない(自動的にはこける)
	# extends in .vscode/extensions/ , configfile in .config/Code/User

def install_web_tools():
	# reference : http://tecadmin.net/install-google-chrome-in-ubuntu/
	run("wget -q -O ./linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub ")
	sudo("apt-key add ./linux_signing_key.pub")
	run("rm ./linux_signing_key.pub")
	sudo("echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list")
	sudo("apt-get update -y", pty=False)
	sudo("apt-get install -y google-chrome-stable", pty=False)

def install_git_and_setting():
	sudo("apt-get install -y git", pty=False)
	run("git config --global user.email \"" + SELF_MAIL_ADDRESS + "\"")
	run("git config --global user.name \"" + USER_NAME  + "\"")
	netrc = """machine github.com
login """ + USER_NAME + """
password """ + GIT_PASS
	run("echo '" + netrc + "' > ~/.netrc")

# 14.04 ではそのパッケージが無い。
# def install_multi_media():
# 	sudo("apt-get install -y ubuntu-restricted-extras", pty=False)

def install_text_editors():
	# editor系一式
	sudo("apt-get install -y leafpad", pty=False)
	# Atom Editor
	sudo("add-apt-repository ppa:webupd8team/atom", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get install atom", pty=False)

