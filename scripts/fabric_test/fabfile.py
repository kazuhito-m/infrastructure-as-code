#coding:utf-8
from fabric.api import local, run, sudo, put, env

SELF_MAIL_ADDRESS = "test@gmail.com"
USER_NAME = "kazuhito-m"
GIT_PASS = "xxxx"

# 実行前に、以下のじゅんびが　必要です
#
# 上部の定数を個人設定の本当の値に置き換える
# ./resource/.dropbox_uploader に値をいれたものを配置する
#
def setup_all():
	all_upgrade()
	japanize()
	rename_home_template_dirs()
	basic_tools_setup()
	install_common_tools()
	install_asciidoc()
	# install_network_tools()
	install_modan_fonts()
	# install_vncserver()
	install_web_tools()
	install_git_and_setting()
	install_text_editors()
	install_vim_all()
	# install_multi_media()
	install_drowing_tools()
	# install_jenkins()
	install_dtm_tools()
	install_system_maintenance()
	install_developers_tools()
	install_provisioning_tools()
	install_msvsc()
	install_nodejs()
	install_plantuml()
	install_scala_and_sbt()
	install_golang()
	# install_touchpad_controltool()
	# install_docker_latest()
	install_communication_tools()
	insatll_sdkman_and_gradle()

def japanize():
	# change locale
	sudo("apt-get install -y language-pack-ja ibus-mozc", pty=False)
	sudo("update-locale LANG=ja_JP.UTF-8")
	# change timezone
	sudo("mv /etc/localtime{,.org}")
	sudo("ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime")

def all_upgrade():
	sudo("apt-get update", pty=False)
	# sudo("do-release-upgrade -d", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get upgrade -y", pty=False)
	sudo("apt-get dist-upgrade -y", pty=False)

def rename_home_template_dirs():
	run("LC_ALL=C xdg-user-dirs-update --force")
	run("find ~/ -maxdepth 1 -type d  | LANG=C grep  -v '^[[:cntrl:][:print:]]*$' | xargs rm -rf")

def basic_tools_setup():
	# sudo("apt-get install -y curl nautilus-dropbox nautilus-open-terminal nautilus-actions ca-certificates openssl unity-tweak-tool" , pty=False)
	sudo("apt-get install -y curl nautilus-dropbox nautilus-actions ca-certificates openssl nkf cifs-utils unity-tweak-tool" , pty=False)

def install_common_tools():
	sudo("apt-get install -f -y stopwatch convmv incron indicator-multiload tree indicator-multiload clipit freemind xbacklight byobu pandoc ffmpeg", pty=False)

def install_asciidoc():
	sudo("apt-get install -f -y asciidoc asciidoctor asciidoctor-doc fop fop-doc", pty=False)

def install_network_tools():
	sudo("apt-get install -y wireshark", pty=False)

def install_modan_fonts():
	sudo("apt-get install -y fonts-migmix" , pty=False)
	# dropboxからフォントを落とす
	sudo("apt-get install -y curl", pty=False)
	run("wget --no-check-certificate -O /tmp/dropbox_uploader.sh https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh")
	run("chmod +x /tmp/dropbox_uploader.sh")
	# 設定ファイルをプット
	put("./resources/.dropbox_uploader" , "/tmp/.dropbox_uploader")
	run("/tmp/dropbox_uploader.sh -k -f/tmp/.dropbox_uploader download /fonts/ /tmp/fonts")
	# DropBox内にあったスクリプトで全量インストール
	sudo("cd /tmp/fonts/ && for i in $(find ./ -type f | grep -i '^.*\..t.$') ; do cp ${i} /usr/local/share/fonts/ ; done")
	sudo("chmod 644 /usr/local/share/fonts/*")
	sudo("fc-cache -fv")

def install_vncserver():
	sudo("apt-get install -y gnome-core ubuntu-desktop tightvncserver", pty=False)
	run("rm -rf ~/.vnc")
	put("./resources/.vnc/","~/")
	run("chmod 600 ~/.vnc/passwd")
	run("chmod 755 ~/.vnc/xstartup")

def install_web_tools():
	# reference : http://tecadmin.net/install-google-chrome-in-ubuntu/
	# 同じ処理を「ファイルの名前だけ変えて」やってる気がするので、片方はコメントアウト(問題あるなら修正すること)
	# run("wget -q --no-check-certificate -O ./linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub ")
	# sudo("apt-key add ./linux_signing_key.pub")
	# run("rm ./linux_signing_key.pub")
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

def install_multi_media():
	# なぜか、14以降のUbuntuではパッケージなくなってるきがする…環境依存？
	# sudo("apt-get install -f -y ubuntu-restricted-extras", pty=False)
	# ※どうしても対話型になるので、後で入れる
	# TODO CLIだけで片付ける方法
	# TODO ↓のリポジトリもなくなっているので、ffmpegを入れる方法
	# ffmpeg
	# sudo("apt-add-repository -y ppa:samrog131/ppa", pty=False)
	sudo("apt-get update", pty=False)
	# sudo("apt-get install ffmpeg-real", pty=False)
	# run("'export PATH=${PATH}:/opt/ffmpeg/bin' >> ~/.bashrc")

def install_text_editors():
	# editor系一式
	sudo("apt-get install -y leafpad", pty=False)
	# Atom Editor
	# sudo("add-apt-repository -y ppa:webupd8team/atom", pty=False)
	# sudo("apt-get update", pty=False)
	# sudo("apt-get install atom", pty=False)
	run("wget --no-check-certificate -O /tmp/atom.deb https://atom.io/download/deb")
	sudo("dpkg -i /tmp/atom.deb")
	# plugin設定
	run("apm install plantuml-viewer language-plantuml japanese-menu markdown-scroll-sync") # http://pierre3.hatenablog.com/entry/2015/08/23/220217
	# TODO Reafpad,gedtの設定ファイル持ってくる。

def install_vim_all():
	sudo("apt-get install -y vim", pty=False)
	put("./resources/.vimrc","~/.vimrc")
	run("mkdir -p ~/.vim/bundle")
	run("rm -rf ~/.vim/bundle/neobundle.vim")  # 二回目以降の冪当性確保(手動設定を全てご破算にしてしまうのはいかがなものか)
	run("git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")

def install_drowing_tools():
	sudo("apt-get install -y gimp pinta imagemagick graphicsmagick byzanz", pty=False)
	# アニメGIFを作るツールの動作方法は…
	# xwininfo # ここでウィンドウを指定し、情報を取得する
	# byzanz-record -d 180 -x 1379 -y 234 -w 1008 -h 722 test2.gif # その情報を元にキャプチャを始める。(終了したくなったらCtrl+c)
	# TODO 上を上手いことやるscriptを作る

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
	sudo("apt-get install -y gparted gpart unetbootin tree", pty=False)

def install_developers_tools():
	# java8 installl
	sudo("apt-get install -y openjdk-8-jdk galternatives", pty=False)
	# Fablic install.
	# VCS visualize tools
	# sudo("apt-get install -y rapidsvn", pty=False)	# SVNこれから要らなくなるだろうからパス
	sudo("apt-get install -y rabbitvcs-nautilus rabbitvcs-gedit rabbitvcs-cli", pty=False)
	# datavese viewer
	sudo("apt-get install -y libqt4-sql-mysql libqt4-sql-psql libqt4-sql-sqlite libqt4-sql-odbc libqt4-sql-tds tora", pty=False)

def install_provisioning_tools():
	sudo("apt-get install -y fabric", pty=False)
	sudo("apt-get install -y python-pip", pty=False)
	sudo("pip install ansible", pty=False)

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
 	# scala install
 	SCALA_VER='2.12.0-M3'
 	run("wget -O /tmp/scala.deb http://www.scala-lang.org/files/archive/scala-" + SCALA_VER + ".deb")
 	sudo("dpkg -i /tmp/scala.deb" , pty=False)
 	# sbt apt regist
   	sudo("mkdir -p /etc/apt/sources.list.d/")
   	sudo("echo 'deb https://dl.bintray.com/sbt/debian /' > /etc/apt/sources.list.d/sbt.list")
    	sudo("apt-get update" , pty=False)
   	sudo("apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823", pty=False)
   	sudo("apt-get update -y" , pty=False)
   	sudo("apt-get install -y sbt", pty=False)
  	# conscript , giter8 (この技術は廃れるかもしれない。試験導入。)
	sudo("apt-get install -y curl", pty=False)
 	run("wget -O /tmp/sc_setup.sh https://raw.github.com/n8han/conscript/master/setup.sh")
 	run("chmod 755 /tmp/sc_setup.sh")
 	run("/tmp/sc_setup.sh")
 	run("cs n8han/giter8")

def install_golang():
	# sudo("add-apt-repository -y ppa:evarlast/golang1.5", pty=False)
	# sudo("apt-get update")
	# sudo("apt-get install -y golang")
	# 上記APTラインは使えなくなった模様。手動で入れるやり方に切り替え。
	run("wget -O /tmp/golang.tar.gz https://storage.googleapis.com/golang/go1.6rc2.linux-amd64.tar.gz")
	sudo("tar -C /usr/local -xzf /tmp/golang.tar.gz")
	run("echo 'export GOROOT=/usr/local/go' >> ~/.bashrc")
	run("echo 'export PATH=$GOROOT/bin:$PATH' >> ~/.bashrc")
	# GOPATH系の設定
	run("echo 'export GO_WORKSPACE=current' >> ~/.bashrc")
	run("echo 'export GOPATH=~/go/third:~/go/${GO_WORKSPACE}' >> ~/.bashrc")
	run("echo 'export PATH=${PATH}:~/go/third/bin:~/go/${GO_WORKSPACE}/bin' >> ~/.bashrc")
	run("mkdir -p ~/go/{third,${GO_WORKSPACE}}")
	run("mkdir -p ~/go/${GO_WORKSPACE}/{src,bin,pkg}")
	# InteliJ Ideaにgo-langの開発環境を設定
	# 基本的には、[ここ](http://stormcat.hatenablog.com/entry/2015/04/13/123000)をトレースする。

# touchpadを無効化するツールをインストール
def install_touchpad_controltool():
	sudo("add-apt-repository -y ppa:atareao/atareao")
	sudo("apt-get update" , pty=False)
	sudo("apt-get install -y touchpad-indicator", pty=False)

def install_docker_latest():
        # refalance https://docs.docker.com/engine/installation/linux/ubuntulinux/
        sudo("apt-get update" , pty=False)
        sudo("apt-get install -y apt-transport-https ca-certificates" , pty=False)
        sudo("apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D")
        sudo("echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list")
        sudo("apt-get update" , pty=False)
        sudo("apt-get purge -y lxc-docker" , pty=False)
        sudo("apt-get install -y linux-image-extra-$(uname -r)" , pty=False)
        sudo("apt-get install -y docker-engine", pty=False)
        sudo("service docker start")
        sudo("docker run hello-world")
        # インストール直後は、"Cannot connect to the Docker daemon. Is the docker daemon running on this host?" と表示されるものの
        # 再起動後は軽快に動く。

def install_communication_tools():
	run("wget -O /tmp/slack-desktop.deb https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/slack-desktop-1.2.5-amd64.deb")
	sudo("dpkg -i /tmp/slack-desktop.deb ", pty=False)

def insatll_virtualbox():
        sudo("apt-get install -y vertualbox")

def insatll_sdkman_and_gradle():
	run("curl -s get.sdkman.io | bash")
	run("sdk install gradle")

# TODOList
# + Amazonの検索とか「余計なお世話」を殺す
#   + http://ubuntuapps.blog67.fc2.com/blog-entry-695.html
# + 拡張子から起動するアプリケーションの関連付け
#   + http://pctonitijou.blog.fc2.com/blog-entry-230.html
