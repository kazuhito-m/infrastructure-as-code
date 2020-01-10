# vagrantで仮想機立てて、プロビジョニングを実行するスクリプト

# 「このスクリプトがある場所」まで移動
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

pushd ./test/vagrant

# VagrantのNoPassログイン用鍵を作成する
if [ ! -d .tmp/ ]; then
    mkdir .tmp
fi
if [ ! -f .tmp/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -C "kazuhito@example.com" -N '' -f .tmp/id_rsa
    chmod 400 .tmp/id_rsa*
fi

# Vagrant box 起動
vagrant up

popd

# Ansbile実行
export ANSIBLE_HOST_KEY_CHECKING=False  # known_hosts の判定を回避

ansible-playbook \
    --timeout=180 \
    -i ./test/vagrant/vagrant_hosts main.yml \
    -u vagrant \
    --private-key=./test/vagrant/.tmp/id_rsa
