#!/bin/bash

# script file location
DOTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Reset and update OMZ git repo
cd ~/.oh-my-zsh/
git reset --hard HEAD
cd $DOTDIR

# Update OMZ
env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh

# Delete custom folder and link to dotfiles version
if [ -d ~/.oh-my-zsh/custom ]; then
    rm -rf ~/.oh-my-zsh/custom
fi
ln -s $DOTDIR/custom ~/.oh-my-zsh/custom
