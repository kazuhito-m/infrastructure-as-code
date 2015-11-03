#coding:utf-8
from fabric.api import local, run, sudo, put

SELF_MAIL_ADDRESS = "sumpic@hotmail.com"
USER_NAME = "kazuhito-m"
GIT_PASS = "xxxx"

def setup_all():
	all_upgrade()
	# japanize()
	# install_vncserver()
	rename_home_template_dirs()
	install_modan_fonts()
	install_web_tools()
	install_git_and_setting()
	# install_multi_media()
	install_text_editors()
	install_drowing_tools()
	install_dtm_tools()
	install_system_maintenance()
	install_common_tools()
	install_developers_tools()
	install_msvsc()
	install_plantuml()
	# install_jenkins()
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

def install_modan_fonts():
	sudo("apt-get install -y fonts-migmix" , pty=False)
	# TODO 自身のいつも使ってるフォントを追加。

def install_vncserver():
	sudo("apt-get install -y gnome-core ubuntu-desktop tightvncserver", pty=False)
	run("rm -rf ~/.vnc")
	put("./resources/.vnc/","~/")
	run("chmod 600 ~/.vnc/passwd")
	run("chmod 755 ~/.vnc/xstartup")

def install_web_tools():
	# reference : http://tecadmin.net/install-google-chrome-in-ubuntu/
	run("wget -q -O ./linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub ")
	sudo("apt-key add ./linux_signing_key.pub")
	run("rm ./linux_signing_key.pub")
	# sudo("echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list")
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
	# plugin設定
	run("apm install plantuml-viewer language-plantuml") # http://pierre3.hatenablog.com/entry/2015/08/23/220217
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
	sudo("apt-get install -y audacity rosegarden hydrogen ardour", pty=False)
	# ソフトシンセや「音源材料」系
	sudo("apt-get install -y qsynth fluid-soundfont-gm cmt calf-plugins caps tap-plugins invada-studio-plugins-lv2 swh-lv2 mda-lv2", pty=False)

def install_system_maintenance():
	sudo("apt-get install -y gparted unetbootin tree", pty=False)

def install_common_tools():
	sudo("apt-get install -y stopwatch", pty=False)

def install_developers_tools():
	# java8 installl
	sudo("apt-get install -y openjdk-8-jdk", pty=False)
	# Fablic install.
	sudo("apt-get install -y fabric", pty=False)

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

def install_nodejs():
	# 最初はPPAでやろうとおもったが…なくなってるみたいなので、しゃーなしでスクリプトでやることに
	# sudo("add-apt-repository ppa:chris-lea/node.js", pty=False)
	# sudo("sudo apt-get update -y", pty=False)
	# sudo("sudo apt-get install -y nodejs npm", pty=False)
	run("wget -O /tmp/setup_nodejs https://deb.nodesource.com/setup_0.12")
	sudo("bash /tmp/setup_nodejs", pty=False)
	sudo("apt-get install -y nodejs", pty=False)
	run("node -v")
	
def install_plantuml():
	# 要るものは予め落としておく
	run("wget -O /tmp/plantuml.jar http://downloads.sourceforge.net/project/plantuml/plantuml.jar")
	# debパッケージ入れた後 最新Jarで上書き…とかしようと思ったがうまくいかなかったので、debのインストールと同じ構成を自力で作る。
	sudo("mkdir -p /usr/share/plantuml/")
	sudo("mv /tmp/plantuml.jar /usr/share/plantuml/")
	sudo("chmod 755 /usr/share/plantuml/plantuml.jar")
	sudo("echo 'java -jar /usr/share/plantuml/plantuml.jar ${@}' > /usr/bin/plantuml")
	sudo("chmod 755 /usr/bin/plantuml")
 	# atomがインストールされていた場合、atomのプラグインを入れる
 	run("which atom && apm install  plantuml-viewer language-plantuml")

def install_scala_and_sbt():
	SCALA_VER='2.12.0-M2'
	SBT_VER='0.13.9'
	run("wget -O /tmp/scala.deb http://www.scala-lang.org/files/archive/scala-" + SCALA_VER + ".deb")
	run("wget -O /tmp/sbt.deb https://dl.bintray.com/sbt/debian/sbt-" + SBT_VER + ".deb")
	sudo("apt-get update" , pty=False)
	sudo("dpkg -i /tmp/scala.deb /tmp/sbt.deb")
	# conscript , giter8 (この技術は廃れるかもしれない。試験導入。)
	run("wget -O sc_setup.sh https://raw.github.com/n8han/conscript/master/setup.sh")
	run("chmod 755 /tmp/sc_setup.sh")
	run("/tmp/setup.sh")
	run("^/bin/cs n8han/giter8")


