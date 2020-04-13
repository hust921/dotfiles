#!/bin/bash
readonly PLUGDIR="$HOME/dotfiles/plugins"
cd "$PLUGDIR"

# === zsh-completions
if [ -d 'zsh-completions' ]; then
    cd 'zsh-completions'
    git reset --hard HEAD
    git pull
    cd "$PLUGDIR"
else
    git clone https://github.com/zsh-users/zsh-completions
fi

# === zsh-autosurggestion
if [ -d 'zsh-autosuggestions' ]; then
    cd 'zsh-autosuggestions'
    git reset --hard HEAD
    git pull
    cd "$PLUGDIR"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions
fi

# === zsh-syntax-highlight
if [ -d 'zsh-syntax-highlighting' ]; then
    cd 'zsh-syntax-highlighting'
    git reset --hard HEAD
    git pull
    cd "$PLUGDIR"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi

# ============================== 
# ===      CLEAR CACHE       === 
# ============================== 
rm -rf zcompdump*
