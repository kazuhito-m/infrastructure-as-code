#!/bin/bash

# ASUS C300  Special Settings 

## swap
sudo dd if=/dev/zero of=/home/swap0 bs=1M count=8192
sudo chmod 600 /home/swap0 
sudo mkswap /home/swap0 
sudo swapon /home/swap0
sudo echo '/home/swap0 swap swap defaults 0 0' >> /etc/fstab 
