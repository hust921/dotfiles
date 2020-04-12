#!/bin/bash

# script file location
DOTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "$HOME/.oh-my-zsh/"
git reset --hard HEAD
local gitreset=$?
cd $DOTDIR
if [[ "$gitreset" != 0 ]]; then
    exit 1
fi

# Update OMZ
env ZSH="$HOME/.oh-my-zsh" /bin/sh -c '
    chmod u+x "$ZSH/tools/upgrade.sh"
    yes | "$ZSH/tools/upgrade.sh"' || exit 1

# Delete custom folder and link to dotfiles version
if [ -d ~/.oh-my-zsh/custom ]; then
    rm -rf ~/.oh-my-zsh/custom || exit 1
fi
ln -s $DOTDIR/custom ~/.oh-my-zsh/custom || exit 1
