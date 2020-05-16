#!/bin/bash

# ===== Default / Options / Flags =====
readonly INSTALL_VERSION="0.1.0"
FLAG_i=false
FLAG_d=false
readonly DOTDIR="$HOME/dotfiles"

# ===== Global Settings / Variables =====
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 

# ===== Installing System Dependencies =====
sudo apt-get update -y && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y sudo curl git gcc

# ===== Cloning Repository & Installing hustly.sh =====
git clone -b develop https://github.com/hust921/dotfiles.git "$DOTDIR"
sudo ln -s "$DOTDIR/hustly.sh" "/usr/local/bin/hustly"
sudo chmod 751 "/usr/local/bin/hustly"

# ===== Ready for Running =====
/usr/local/bin/hustly -h
