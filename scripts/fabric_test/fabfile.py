#coding:utf-8
from fabric.api import local, run, sudo, put

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

def install_vncserver():
	sudo("apt-get install -y gnome-core ubuntu-desktop tightvncserver", pty=False)
	run("rm -rf ~/.vnc")
	put("./resources/.vnc/","~/")
	run("chmod 600 ~/.vnc/passwd")
	run("chmod 755 ~/.vnc/xstartup")

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
	sudo("apt-get install -y leafpad vim", pty=False)
	# Atom Editor
	sudo("add-apt-repository ppa:webupd8team/atom", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get install atom", pty=False)
	# TODO Reafpad,gedtの設定ファイル持ってくる。

def install_drowing_tools():
	sudo("apt-get install -y gimp pinta imagemagick", pty=False)

def install_jenkins():
	run("wget -q -O /tmp/jenkins-ci.org.key https://jenkins-ci.org/debian/jenkins-ci.org.key")
	sudo("apt-key add /tmp/jenkins-ci.org.key", pty=False)
	sudo("sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'")
	sudo("apt-get -y update", pty=False)
	sudo("apt-get install -y jenkins", pty=False)
	# これだけで入るので、あとは http://locahost:8080 で確認。
	# 最初に二つのプラグインを入れる
	# + Post build task
	# + CloudBees Folders Plugin
	# その後、Jobを固めたファイルを然るべきところに展開する。
	# sudo su jenkins
	# tar xzf ./resources/jenkins_jobs.tgz
	# mv /var/lib/jenkins/jobs /var/lib/jenkins/jobs.org
	# mv ./jobs /var/lib/jenkns/jobs
	# exit
	# TODO ここの上の実装
	sudo("update-rc.d jenkins default")
	sudo("service jenkins start")

def install_dtm_tools():
	# DTM関係よろずインストール
	sudo("apt-get install -y rosegarden hydrogen ardour", pty=False)
	# ソフトシンセや「音源材料」系
	sudo("apt-get install -y qsynth fluid-soundfont-gm cmt calf-plugins caps tap-plugins invada-studio-plugins-lv2 swh-lv2 mda-lv2", pty=False)

def install_system_maintenance():
	sudo("apt-get install -y gparted unetbootin tree", pty=False)

def install_common_tools():
	sudo("apt-get install -y stopwatch", pty=False)

