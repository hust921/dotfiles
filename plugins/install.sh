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

# === zsh-autopair
if [ -d 'zsh-autopair' ]; then
    cd 'zsh-autopair'
    git reset --hard HEAD
    git pull
    cd "$PLUGDIR"
else
    git clone https://github.com/hlissner/zsh-autopair
fi

# === zsh-autoswitch-virtualenv
if [ -d 'autoswitch_virtualenv' ]; then
    cd 'autoswitch_virtualenv'
    git reset --hard HEAD
    git pull
    cd "$PLUGDIR"
else
    git clone https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv autoswitch_virtualenv
fi


# === jq-zsh-plugin
if [ -d 'jq' ]; then
    cd 'jq'
    git reset --hard HEAD
    git pull
    cd "$PLUGDIR"
else
    git clone https://github.com/reegnz/jq-zsh-plugin.git jq
fi

# ============================== 
# ===      CLEAR CACHE       === 
# ============================== 
rm -rf zcompdump*
