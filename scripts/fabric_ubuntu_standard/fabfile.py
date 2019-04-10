#coding:utf-8
from fabric.api import local, run, sudo, put, env, settings

SELF_MAIL_ADDRESS = "xxx@gmail.com"
USER_NAME = "kazuhito"
GIT_USER = "kazuhito-m"
GIT_PASS = "xxx"

# 実行前に、以下のじゅんびが　必要です
#
# 上部の定数を個人設定の本当の値に置き換える
# ./resource/.dropbox_uploader に値をいれたものを配置する
#
# またローカルサーバに入れるときは、以下のインストールを予めする必要がある。
# - git,fabricのインストール
# - ssh で「自端末にログインできる」ようにしておく。

def setup_all():
	all_upgrade()
	# japanize() # 日本語Limux”以外”を使う場合はonにする
	rename_home_template_dirs()
	basic_tools_setup()
	install_common_tools()
	# install_movie_player()
	install_asciidoc()
	# install_network_tools()
	install_rescure_tools()
	install_modan_fonts()
	# install_vncserver()
	install_web_tools()
	install_git_and_setting()
	install_text_editors()
	install_vim_all()
	install_gcp_sdk()
	# install_multi_media()
	install_drowing_tools()
	# install_jenkins()
	# install_dtm_tools()
	install_system_maintenance()
	install_developers_tools()
	install_provisioning_tools()
	install_msvsc()
	install_nodejs()
	install_plantuml()
	install_screencapture_gif()
	install_scala_and_sbt()
	install_golang()
	# install_touchpad_controltool()
	install_docker_latest()
	install_communication_tools()
	# bug , Ubuntu16.10にて「sdkmangでgradle入れたときに、Ubuntuにログインできなくなる(ログイン画面->パスワード入力&Enter->”トコトン音”とともに再びログイン画面)」となるため、コメントアウト。
	# insatll_sdkman_and_gradle()
	install_intellij()
	install_game()
	# 途中で対話型が入る＆特定端末でしか重くて動かせないので、第一次候補からははずす。
	# install_android_env()
	# install_kvm() # ネットワークがおかしくなるリスク在る…ので、後付で設定
	install_ngrok()
        config_current_user()

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

	sudo("apt-get install -y curl nautilus-actions ca-certificates openssl nkf cifs-utils unity-tweak-tool" , pty=False)
def install_common_tools():
	sudo("apt-get install -f -y stopwatch convmv incron indicator-multiload tree clipit xbacklight byobu screen pandoc ffmpeg comix unrar nkf apt-file", pty=False)
	# DVD movie play
	sudo("apt-file update")
	# UI Customize tools
	sudo("apt-get install -y gnome-tweak-tool", pty=False)
	# Dropbox
	install_dropbox_client()
	# GoogleDrive
	install_googledrive_client()
	# ResilioSync
	install_resiliosync()

def install_movie_player():
	sudo("apt-get install -y ubuntu-restricted-extras  vlc libdvd-pkg")
	sudo("dpkg-reconfigure libdvd-pkg")
	run("file /usr/lib/x86_64-linux-gnu/libdvdcss.so")

def install_asciidoc():
	sudo("apt-get install -f -y asciidoc asciidoctor asciidoctor-doc fop fop-doc", pty=False)

def install_network_tools():
	sudo("apt-get install -y wireshark", pty=False)

def install_rescure_tools():
	sudo("apt-get install -f -y testdisk foremost", pty=False)

def install_modan_fonts():
	sudo("apt-get install -y fonts-migmix" , pty=False)
	# dropboxからフォントを落とす
	sudo("apt-get install -y curl", pty=False)
	run("wget --no-check-certificate -O /tmp/dropbox_uploader.sh https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh")
	run("chmod +x /tmp/dropbox_uploader.sh")
	# 設定ファイルをプット
	put("./resources/.dropbox_uploader" , "/tmp/.dropbox_uploader")
	run("/tmp/dropbox_uploader.sh -k -f /tmp/.dropbox_uploader download fonts /tmp/fonts")
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
	# もう、あまりにもトラブルので、固定でDebパッケージを入れるように。
	# sudo("echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list")
	# sudo("apt-get update -y", pty=False)
	# sudo("apt-get install --allow-unauthenticated -y google-chrome-stable", pty=False)

	run("curl https://dl.google.com/linux/linux_signing_key.pub > /tmp/linux_signing_key.pub")
	sudo("mkdir -p /usr/lib/pepperflashplugin-nonfree")
	sudo("mv /tmp/linux_signing_key.pub /usr/lib/pepperflashplugin-nonfree/pubkey-google.txt")

	sudo("apt-get install -y libappindicator1 pepperflashplugin-nonfree", pty=False)
	put("./resources/chrome/google-chrome-stable_current_amd64.deb" , "/tmp/chrome.deb")
	sudo("dpkg -i /tmp/chrome.deb")

def install_git_and_setting():
	sudo("apt-get install -y git tig", pty=False)
	run("git config --global user.email \"" + SELF_MAIL_ADDRESS + "\"")
	run("git config --global user.name \"" + GIT_USER  + "\"")
	netrc = """machine github.com
login """ + GIT_USER + """
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
	sudo("apt-get install ffmpeg", pty=False)

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
	run("apm install plantuml-viewer language-plantuml japanese-menu markdown-scroll-sync atom-beautify auto-encoding document-outline") # http://pierre3.hatenablog.com/entry/2015/08/23/220217
	# TODO Reafpad,gedtの設定ファイル持ってくる。

def install_vim_all():
	sudo("apt-get install -y vim", pty=False)
	put("./resources/.vimrc","~/.vimrc")
	run("mkdir -p ~/.vim/bundle")
	run("rm -rf ~/.vim/bundle/neobundle.vim")  # 二回目以降の冪当性確保(手動設定を全てご破算にしてしまうのはいかがなものか)
	run("git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")

# Google Could SDKをインストール(golang用)
	sudo("echo 'deb https://packages.cloud.google.com/apt cloud-sdk-'$(lsb_release -c -s)' main' | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list", pty=False)
	sudo("curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -", pty=False)
	sudo("apt-get update && apt-get install google-cloud-sdk")
	# kubectl install
	sudo("apt-get install kubectl google-cloud-sdk google-cloud-sdk-app-engine-grpc google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datalab google-cloud-sdk-app-engine-java")

def install_drowing_tools():
	sudo("apt-get install -y gimp pinta imagemagick graphicsmagick", pty=False)
	# アニメGIFを作るツールの動作方法は…
	# xwininfo # ここでウィンドウを指定し、情報を取得する
	# byzanz-record -d 180 -x 1379 -y 234 -w 1008 -h 722 test2.gif # その情報を元にキャプチャを始める。(終了したくなったらCtrl+c)

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
	sudo("apt-get install -y postgresql-client-common", pty=False)
	# Mono&MonoDevelop
	sudo("apt-get install -y monodevelop", pty=False)

def install_provisioning_tools():
	sudo("apt-get install -y fabric", pty=False)
	sudo("apt-get install -y python-pip", pty=False)
	sudo("pip install ansible", pty=False)

def install_msvsc():
	run("curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/microsoft.gpg", pty=False)
 	sudo("mv /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg" , pty=False)
	sudo("echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' > /etc/apt/sources.list.d/vscode.list", pty=False)
 	sudo("apt-get update" , pty=False)
 	sudo("apt-get install -y code" , pty=False)

def install_nodejs():
	sudo("apt-get install -y nodejs npm", pty=False)
	sudo("npm cache clean", pty=False)
	sudo("npm install n -g", pty=False)
	sudo("n stable", pty=False)
	sudo("ln -sf /usr/local/bin/node /usr/bin/node", pty=False)
	run("node -v")

def install_plantuml():
		# 前提条件として、使うパッケージ入れとく。
	sudo("apt-get install -y graphviz", pty=False)
	# 要るものは予め落としておく
	run("wget -O /tmp/plantuml.jar http://downloads.sourceforge.net/project/plantuml/plantuml.jar")
	# debパッケージ入れた後 最新Jarで上書き…とかしようと思ったがうまくいかなかったので、debのインストールと同じ構成を自力で作る。
	sudo("mkdir -p /usr/share/plantuml/")
	sudo("mv /tmp/plantuml.jar /usr/share/plantuml/")
	sudo("chmod 755 /usr/share/plantuml/plantuml.jar")
	sudo("echo 'java -jar /usr/share/plantuml/plantuml.jar ${@}' > /usr/bin/plantuml")
	sudo("chmod 755 /usr/bin/plantuml")
 	# atomがインストールされていた場合、atomのプラグインを入れる
 	run("which atom && apm install plantuml-viewer language-plantuml")

# Window/Screenキャプチャをアニメgifで取るコマンドのインストール。
def install_screencapture_gif():
	# 'peek' インストール
	sudo("add-apt-repository ppa:peek-developers/stable", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get install -y peek", pty=False)
	# 'byzanz'（+ wrapper） インストール
	sudo("apt-get install -y byzanz libx11-dev autoconf", pty=False)
	sudo("mkdir -p /usr/local/lib/byzanz-record-wrapper", pty=False)
	# 範囲指定に必要なライブラリをビルド
	run("git clone https://github.com/lolilolicon/xrectsel.git /tmp/xrectsel", pty=False)
	run("cd /tmp/xrectsel && ./bootstrap")
	run("cd /tmp/xrectsel && ./configure")
	sudo("cd /tmp/xrectsel && make", pty=False)
	sudo("cd /tmp/xrectsel && make install", pty=False)
	# Windowのキャプチャコマンド
	sudo("wget -O /usr/local/lib/byzanz-record-wrapper/byzanz-record-window https://gist.githubusercontent.com/toddhalfpenny/50700764071418daa2e446fe58b0cd96/raw/a5eebfa30f5b6546756d7f87dbc8ee08404208f7/byzanz-record-window", pty=False)
	sudo("chmod 755 /usr/local/lib/byzanz-record-wrapper/byzanz-record-window", pty=False)
	sudo("ln -s /usr/local/lib/byzanz-record-wrapper/byzanz-record-window /usr/local/bin/byzanz-record-window", pty=False)
	# 範囲指定のキャプチャコマンド
	sudo("wget -O /usr/local/lib/byzanz-record-wrapper/byzanz-record-region https://gist.githubusercontent.com/haya14busa/0dd3923d2a1b5ea07af2/raw/27a057e93d7336eb31ffed205a9c259ab7d3f489/byzanz-record-region", pty=False)
	sudo("chmod 755 /usr/local/lib/byzanz-record-wrapper/byzanz-record-region", pty=False)
	sudo("ln -s /usr/local/lib/byzanz-record-wrapper/byzanz-record-region /usr/local/bin/byzanz-record-region", pty=False)

def install_scala_and_sbt():
 	# scala install
 	SCALA_VER='2.11.12'
 	run("wget -O /tmp/scala.deb http://www.scala-lang.org/files/archive/scala-" + SCALA_VER + ".deb")
 	sudo("dpkg -i /tmp/scala.deb" , pty=False)
 	# sbt apt regist
   	sudo("mkdir -p /etc/apt/sources.list.d/")
   	sudo("echo 'deb https://dl.bintray.com/sbt/debian /' > /etc/apt/sources.list.d/sbt.list")
	sudo("sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 99E82A75642AC823", pty=False)
   	sudo("apt-get update -y" , pty=False)
   	sudo("apt-get install --allow-unauthenticated -y sbt", pty=False)
  	# conscript , giter8 (この技術は廃れるかもしれない。試験導入。)
	sudo("apt-get install -y curl", pty=False)
 	run("wget -O /tmp/sc_setup.sh https://raw.github.com/n8han/conscript/master/setup.sh")
 	run("chmod 755 /tmp/sc_setup.sh")
 	run("CONSCRIPT_HOME=~/.conscript /tmp/sc_setup.sh")
 	run("~/.conscript/bin/cs n8han/giter8")
		# ここで「プロンプトが出て止まる」場合がある。その場合は"exit"打って続行させる。

def install_golang():
	# sudo("add-apt-repository -y ppa:evarlast/golang1.5", pty=False)
	# sudo("apt-get update")
	# sudo("apt-get install -y golang")

	# 上記APTラインは使えなくなった模様。手動で入れるやり方に切り替え。
	# run("wget -O /tmp/golang.tar.gz https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz")
	# sudo("tar -C /usr/local -xzf /tmp/golang.tar.gz")
	# run("echo 'export GOROOT=/usr/local/go' >> ~/.bashrc")
	# run("echo 'export PATH=$GOROOT/bin:$PATH' >> ~/.bashrc")

	# 上記のやり方も「Versionを固定」しすぎるため、gvmのやり方に変更。
	sudo("apt-get install -y bison", pty=False)
	run("bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)")
	# この後、`gvm listall` で最新を確認、`gvm install [最新] && gvm use [最新] --default` で「使うgoのインストールと選択」を行う。

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
	sudo("apt-get install -y docker-engine docker-compose", pty=False)
	sudo("service docker start")
	# このままでは、一般ユーザでは叩け無いので、グループ設定
	sudo("groupadd -f docker")
	sudo("gpasswd -a " + USER_NAME + " docker")
	# 起動テスト
	sudo("docker run hello-world")
	# インストール直後は、"Cannot connect to the Docker daemon. Is the docker daemon running on this host?" と表示されるものの
	# 再起動後は軽快に動く。

def install_communication_tools():
	run("wget -O /tmp/slack-desktop.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-2.9.0-amd64.deb")
	sudo("dpkg -i /tmp/slack-desktop.deb ", pty=False)
	# 自動起動設定。
	put("./resources/.config/autostart/slack.desktop", "/tmp/slack.desktop")
	sudo("cp /tmp/slack.desktop /home/" + USER_NAME + "/.config/autostart/slack.desktop")

def insatll_virtualbox():
	sudo("apt-get install -y virtualbox")
        # インストール手段はこれで良いのだが…Biosの設定によっては、virtualbox.serviceが起動できない。
        # http://kuchitama.hateblo.jp/entry/ubuntu_secure_boot_probrem
        # Biosにて「セキュアブートを無効化」しなければならない。
        # https://freesoft.tvbok.com/tips/efi_installation/about_secure_boot.html
        # ASUSのBiosでの「セキュアブート無効」は「OtherOS(もしくは日本語で、非UEFIモード)」を選択した状態を指すので、注意。

def insatll_sdkman_and_gradle():
	run("curl -s get.sdkman.io | bash")
	run("sdk install gradle")

def install_intellij():
	sudo("add-apt-repository ppa:ubuntuhandbook1/apps" , pty=False)
	sudo("apt-get update -y" , pty=False)
	sudo("apt-get install -y intellij-idea-community", pty=False)

def install_game():
	sudo("apt-get install -y mame mame-tools gnome-video-arcade joystick jstest-gtk", pty=False)
	run("mkdir -p ~/mame/{nvram,memcard,inp,comments,sta,snap,diff,roms}")
	# TODO デフォルトの mame.ini と色々持ってくる

def install_android_env():
	sudo("apt-add-repository ppa:webupd8team/java" , pty=False)
	sudo("apt-get update" , pty=False)
	sudo("apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default", pty=False)
	sudo("apt-add-repository ppa:paolorotolo/android-studio" , pty=False)
	sudo("apt-get update" , pty=False)
	sudo("apt-get install -y android-studio", pty=False)
	# 現状、http://android.stackexchange.com/questions/145437/reinstall-avd-on-ubuntu-16-04 のようなエラーがあるが、一番最後の対策をすることにより回避している(16.10で治ると書いてあったりする)

def install_dropbox_client():
	# dropbox.deb が依存しているライブラリをインストール。
	sudo("apt-get install -y libpango1.0-0 libpangox-1.0-0", pty=False)
	run("wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2.10.0_amd64.deb -O /tmp/dropbox.deb")
	sudo("dpkg -i --force-conflicts	/tmp/dropbox.deb")
	sudo("dropbox start -i")
	sudo("apt-get install -y nautilus-dropbox", pty=False)

def install_googledrive_client():
	sudo("add-apt-repository ppa:alessandro-strada/ppa" , pty=False)
	sudo("apt-get update" , pty=False)
	sudo("apt-get install -y google-drive-ocamlfuse", pty=False)
	run("mkdir -p ~/GoogleDrive")
	run("echo \"alias gdrive_m='google-drive-ocamlfuse ~/GoogleDrive'\" >> ~/.bashrc")
	run("echo \"alias gdrive_u='fusermount -u ~/GoogleDrive'\" >> ~/.bashrc")

def install_resiliosync():
	run("wget -q -O /tmp/resilio-sync.key.asc https://linux-packages.resilio.com/resilio-sync/key.asc")
	sudo("apt-key add /tmp/resilio-sync.key.asc", pty=False)
	sudo("echo 'deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free' > /etc/apt/sources.list.d/resilio-sync.list")
	sudo("apt-get -y update", pty=False)
	sudo("apt-get install -y resilio-sync", pty=False)
	sudo("systemctl enable resilio-sync", pty=False)
	sudo("gpasswd -a " + USER_NAME + " rslsync")

def install_kvm():
	sudo("apt-get install -y qemu-kvm libvirt0 libvirt-bin virt-manager bridge-utils", pty=False)
	sudo("apt-get install -y ubuntu-fan", pty=False)	# おそらくバグ。
	sudo("update-rc.d libvirtd defaults")
	sudo("gpasswd libvirt -a " + USER_NAME)
	# ネットワーク仮想化のオーバーヘッドを減らすことができるvhost-net を有効に
	sudo("grep 'vhost_net' /etc/modules || echo 'vhost_net' >> /etc/modules")
	# KVMインストール時に作られる仮想ネットワークを無効化する。
	sudo("virsh net-destroy default")
	sudo("virsh net-autostart default --disable")
	# TODO この後、手動にてブリッジ構成にする。
	# ここに関しては各マシン違うと思うので、合わせて以下のサイトの通りにする。
	# http://symfoware.blog68.fc2.com/blog-entry-1877.html
	# おそらく、UbuntuではNetworkManagerとかち合うので、止めるなりなんとかするなりする。
	sudo("apt-get remove -y network-manager", pty=False)
	# TODO ./resoures/apend-interfaces-for-kvm というファイルがあるので、/etc/network/interface に編集・追加する。
	# brctl show で「ブリッジ状態の確認」ができる。

def install_ngrok():
	put("./resources/ngrok/ngrok-stable-linux-amd64.zip", "/tmp/ngrok.zip")
	run("cd /tmp && unzip /tmp/ngrok.zip")
	sudo("mv /tmp/ngrok /usr/local/bin", pty=False)

def install_dotnet_core():
	sudo("curl -sL -o /tmp/packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb", pty=False)
	sudo("dpkg -i /tmp/packages-microsoft-prod.deb", pty=False)
	sudo("add-apt-repository universe", pty=False)
	sudo("apt-get install -y apt-transport-https", pty=False)
	sudo("apt-get update", pty=False)
	sudo("apt-get install -y dotnet-sdk-2.2", pty=False)

def config_current_user():
	# bashrc のカスタマイズ（冪等のため、特定の文字列の行以降を置き換える）
	bashrc_file = '/home/' + USER_NAME + '/.bashrc'
	bashrc_addition_file = '/home/' + USER_NAME + '/.bashrc_addition'
	original_bachrc_cut_command = 'cat ' + bashrc_file + ' | while IFS= read LINE; do [[ "${LINE}" = "# from here addition." ]] && exit 0 ; echo "${LINE}" >>' + bashrc_file + '.modify ; done'
	put('resources/user_home/.bashrc_addition', bashrc_addition_file)
	run(original_bachrc_cut_command)
	run('cat ' + bashrc_addition_file + ' >> ' + bashrc_file + '.modify')
	run('mv ' + bashrc_file + '.modify ' + bashrc_file)
	run('rm ' + bashrc_addition_file)
	# alias ファイルの設置
	put("resources/user_home/.bash_aliases", "/home/" + USER_NAME + "/.bash_aliases", mode=0644)
        # ssh設定をシンボリックリンク
        run('ln -s /home/' + USER_NAME + '/Dropbox/ubuntu_profile/home/kazuhito/.ssh/config  /home/' + USER_NAME  + '/.ssh/config')


# TODOList
# + Amazonの検索とか「余計なお世話」を殺す
#   + http://ubuntuapps.blog67.fc2.com/blog-entry-695.html
# + 拡張子から起動するアプリケーションの関連付け
#   + http://pctonitijou.blog.fc2.com/blog-entry-230.html
