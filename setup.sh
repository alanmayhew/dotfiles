#!/bin/sh

# INSTALL PACKAGES
apt-get update
apt-get upgrade
apt-get install zsh tmux gcc vim git make nmap zsh python python-pip zip -y

# SHELL SETTINGS
# chsh -s $(which zsh) # nvm we're running as root

cp dotfiles/.* ~/

echo "Make sure to change shell to zsh with   chsh -s $(which zsh)"
