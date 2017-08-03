#!/bin/sh

# INSTALL PACKAGES
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install zsh tmux gcc vim git make nmap zsh python python-pip zip -y

cp dotfiles/.* ~/

echo ""
echo ""
echo "======================================================================"
echo "= changing your shell to zsh... (you'll need to enter your password) ="
echo "======================================================================"
echo ""
chsh -s $(which zsh)
