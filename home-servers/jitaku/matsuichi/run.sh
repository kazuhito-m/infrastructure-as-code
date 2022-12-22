# 本ちゃんプロビジョニングを実行するスクリプト

# 「このスクリプトがある場所」まで移動
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)
cd ${SCRIPT_DIR}

# Ansbile実行
export ANSIBLE_HOST_KEY_CHECKING=False  # known_hosts の判定を回避

ansible-playbook \
    main.yml \
    -i ./hosts \
    -u kazuhito \
    --ask-pass \
    --ask-become-pass \
    -e 'ansible_python_interpreter=/usr/bin/python3'


