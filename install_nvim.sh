#!/bin/bash

# "Throw" if any command fail
set -e

# Assumming apt-get
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update -y
sudo apt install neovim python3-neovim python-dev python-pip python3-dev python3-pip
pip3 install pynvim jedi flake8

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir ~/.config
ln -s ~/dotfiles/config/nvim ~/.config/nvim
nvim +PlugInstall +qall
