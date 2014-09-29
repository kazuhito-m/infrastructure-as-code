#!/bin/bash

# サービス起動(二回目以降は再起動)
service sshd restart

# desctopvnc ユーザにて、vncserverを立ち上げる。
su - desktopvnc -c 'vncserver :1' &

# デーモンモードのため「終わらない何か」を起動。
tail -f /dev/null

