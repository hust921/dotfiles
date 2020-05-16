#!/bin/bash
if ! command -v sudo; then
    echo "sudo not available.."
    return 88
fi

# ===== Installing System Dependencies =====
readonly DOTDIR="$HOME/dotfiles"
sudo apt-get update -y && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y sudo wget curl git gcc

# ===== Cloning Repository & Installing hustly.sh =====
git clone -b develop https://github.com/hust921/dotfiles.git "$DOTDIR"
sudo ln -s "$DOTDIR/hustly.sh" "/usr/local/bin/hustly"
sudo chmod 751 "/usr/local/bin/hustly"

# ===== Ready for Running =====
/usr/local/bin/hustly -h
