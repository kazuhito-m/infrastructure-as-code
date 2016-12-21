#!/bin/bash

fab  -H 192.168.1.133 -u ubuntu -i [鍵] japanize
fab  -H 192.168.1.133 -u ubuntu --initial-password-prompt setup_all

