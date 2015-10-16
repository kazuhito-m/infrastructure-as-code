#!/bin/bash

# Vagrant自体をインストールするスクリプト(未整理、後で移動するかも)
# for Ubuntu 15.04

# vi /etc/apt/sources.list
# deb http://download.virtualbox.org/virtualbox/debian vivid contrib
sudo wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install virtualbox

wget -q https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb
sudo dpkg --install vagrant_*.deb
rm vagrant_*.deb

