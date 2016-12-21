#!/bin/bash

fab  -H 54.178.170.79 -u ubuntu -i [鍵] japanize
fab  -H 54.178.170.79 -u ubuntu --initial-password-prompt setup_all

