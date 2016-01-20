#!/bin/bash

# Lenovo G50-30 Special Settings (wifi)
sudo rmmod ideapad_laptop
echo "blacklist ideapad_laptop" | sudo tee -a /etc/modprobe.d/blacklist-ideapad.conf
