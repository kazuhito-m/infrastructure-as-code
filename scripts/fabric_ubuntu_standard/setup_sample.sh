#!/bin/bash

fab -H localhost -u kazuhito --initial-password-prompt setup_all
# fab -H 192.168.1.72 -u kazuhito --initial-password-prompt setup_all
# fab -H localhost -u kazuhito --initial-password-prompt install_strage_client
