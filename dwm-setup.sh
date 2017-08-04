#!/bin/sh

mkdir wallpapers

apt-get update
apt-get install xorg build-essential libx11-dev libxinerama-dev sharutils libxft-dev suckless-tools

mkdir ~/dwm
git clone http://git.suckless.org/dwm ~/dwm
cp -p dwm-things/config.h ~/dwm
cp -rp dwm-things/mystatus ~/dwm

make -C ~/dwm clean install
