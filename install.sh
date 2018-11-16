#!/bin/bash

set -e

if ! type "git" > /dev/null; then
    echo "You need install git before continue."
    exit 1
fi

# Install .vimrc

if [ -f "$HOME/.vimrc" ]
then
    while true
    do
        read -p "Do you want to override your .vimrc file? " yn
        case $yn in
            [Yy]* ) 
                echo "Overriding .vimrc"
                cp ./vimrc ~/.vimrc
                break;;
            [Nn]* ) 
                echo ".vimrc is NOT overrided"
                exit;;
        esac
    done
else
    echo "Installing .vimrc"
    cp ./vimrc ~/.vimrc
fi

# Install .vim directory

VIM_HOME=$HOME/.vim

if [ -d "$VIM_HOME" ]
then
    while true
    do
        read -p "Do you want to override your .vim directory? " yn
        case $yn in
            [Yy]* ) 
                echo "Installing addons"
                break;;
            [Nn]* ) 
                echo "Addons will not be installed."
                exit;;
        esac
    done
fi

rm -rf $VIM_HOME

mkdir -p $VIM_HOME/autoload
mkdir -p $VIM_HOME/bundle
mkdir -p $VIM_HOME/colors

# Install Plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install theme
cp jellybeans.vim $VIM_HOME/colors/

# Install Plugins Using Plug
vim '+PlugInstall' '+qa!'
