#!/bin/sh

mkdir wallpapers

apt-get update
apt-get install xorg build-essential libx11-dev libxinerama-dev sharutils

mkdir ~/dwm
git clone http://github.com/sr/dwm ~/dwm
cp dwm-things/config.h ~/dwm
cp -r dwm-things/mystatus ~/dwm

make -C ~/dwm clean install
