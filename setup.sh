#!/bin/sh

# INSTALL PACKAGES
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install zsh tmux gcc vim ctags git make python3 python3-pip zip htop curl wget -y

cp dotfiles/.* ~/

read -p "Enter email (for git config): " email
sed "s/~EMAIL~/$email/" dotfiles/gitconfig.template > ~/.gitconfig

echo ""
echo ""
echo "======================================================================"
echo "= changing your shell to zsh... (you'll need to enter your password) ="
echo "======================================================================"
echo ""
chsh -s $(which zsh)
