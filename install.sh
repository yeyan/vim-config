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

# Install Pathogen
curl -s "https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim" -o $VIM_HOME/autoload/pathogen.vim

# Install theme
cp jellybeans.vim $VIM_HOME/colors/

declare -a repos=(
    # Markdown previewer 
    "git@github.com:shime/vim-livedown.git"

    # Source code formatter
    "git@github.com:Chiel92/vim-autoformat.git"

    # File browser
    "git@github.com:scrooloose/nerdtree.git"

    # Tag browser with ctags
    "git@github.com:majutsushi/tagbar.git"

    # Cassandra CQL
    "git@github.com:elubow/cql-vim.git"

    # Check Syntax for multiple languages
    "git@github.com:vim-syntastic/syntastic.git"

    # Vim shell and dependencies
    "git@github.com:Shougo/vimproc.vim.git"
    "git@github.com:Shougo/vimshell.vim.git"
    )

# Clone all add-ons into bundle

cd $VIM_HOME/bundle
for repo in "${repos[@]}"
do
    echo "Installing $repo"
    git clone --depth 1 --quiet $repo > /dev/null
done
cd -

# Compile vimproc

cd $VIM_HOME/bundle/vimproc.vim
make
cd -
