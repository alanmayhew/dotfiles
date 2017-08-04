#!/bin/sh

apt-get update
apt-get install xorg build-essential libx11-dev libxinerama-dev sharutils libxft-dev suckless-tools -y

mkdir ~/dwm
mkdir ~/wallpapers
git clone http://git.suckless.org/dwm ~/dwm
cp -p dwm-things/config.h ~/dwm
cp -rp dwm-things/mystatus ~/dwm

make -C ~/dwm clean install
