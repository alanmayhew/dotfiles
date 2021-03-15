#!/bin/bash

SYMLINK_DOTFILES=0
SYMLINK_SCRIPTS=1

LS_COLORS_URL="https://github.com/trapd00r/LS_COLORS"

pushd $(dirname $0)

_link_in_home () {
    ln -s $(realpath $1) ~/$(basename $1)
}
_copy_to_home () {
    cp $1 ~/
}

put_in_home_dir () {
    # put_in_home_dir <make-link> <path>
    if [ $1 -eq 1 ]; then
        _link_in_home $2
    else
        _copy_to_home $2
    fi
}

prompt_check () {
    # prompt_check <msg>
    read -p "$1? y/n " -n 1 -r
    echo ""
    if [ $REPLY = "y" ] || [ $REPLY = "Y" ]; then
        return 0
    fi
    return 1
}

# INSTALL PACKAGES
if (prompt_check "Update and install packages"); then
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install zsh tmux gcc vim ctags git make python3 python3-pip flake8 zip htop curl wget rsync -y
fi

# DOTFILES
for dotfile in $(find ./dotfiles -type f); do
    put_in_home_dir $SYMLINK_DOTFILES $dotfile
done

# SCRIPTS
for script in $(find ./scripts -type f); do
    put_in_home_dir $SYMLINK_SCRIPTS $script
done

# SET UP EXTRA VIM STUFF
rsync -r -u ./vim/ ~/.vim/

# GITCONFIG
read -p "Enter email (for git config): " email
sed "s/~EMAIL~/$email/" ./gitconfig.template > ~/.gitconfig

# SWITCH SHELL TO ZSH
echo ""
echo ""
echo "======================================================================"
echo "= changing your shell to zsh... (you'll need to enter your password) ="
echo "======================================================================"
echo ""
chsh -s $(which zsh)

# LS COLORS
if (which git > /dev/null); then
    git clone "$LS_COLORS_URL" ~/LS_COLORS
    dircolors -b ~/LS_COLORS/LS_COLORS > ~/LS_COLORS/ls_colors.sh
fi

