#!/bin/bash

# サービス起動(二回目以降は再起動)
service ssh restart
service redis-server restart

# デーモンモードのため「終わらない何か」を起動。
tail -f /dev/null

