# vagrantで仮想機立てて、プロビジョニングを実行するスクリプト

# 「このスクリプトがある場所」まで移動
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

pushd ./test/vagrant
vagrant up

popd

