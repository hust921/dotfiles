#!/bin/bash

# script file location
DOTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Ask a Y/N question
function question {
    echo $1
    ret=1
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) ret=0; break;;
            No  ) ret=1; break;;
        esac
    done

    return $ret
}


# If root ask user if sure
if [[ $UID == 0 ]]; then
    echo "**WARNING!"
    echo "You are running as root!"
    echo "This script will install the dotfiles in root home"
    echo ""
    if question "Are you sure you want to continue?"; then
        exit
    fi
fi

# Replace conkyrc
if question "Do you want to install conkyrc?"; then
    # If .conkyrc exist
    if [ -f ~/.conkyrc ]; then
        echo "~/.conkyrc already exist."
        if question "Do you want to delete it?"; then
            rm ~/.conkyrc
            ln -s $DOTDIR/conkyrc ~/.conkyrc
        fi
    else
        ln -s $DOTDIR/conkyrc ~/.conkyrc
    fi
fi

# Replace vim & vimfiles
if question "Do you want to install vimrc and vimfiles?"; then
    # If .vimrc exist
    if [ -f ~/.vimrc ] || [ -d ~/vimfiles ]; then
        echo "vimrc and vimfiles already exist."
        if question "Do you want to delete them?"; then
            rm ~/.vimrc
            rm -rf ~/vimfiles
            ln -s $DOTDIR/vimrc ~/.vimrc
            ln -s $DOTDIR/vimfiles ~/vimfiles
        fi
    else
        ln -s $DOTDIR/vimrc ~/.vimrc
        ln -s $DOTDIR/vimfiles ~/vimfiles
    fi
fi

# Replace oh-my-zsh files
if question "Do you want to install oh-my-zsh files?"; then
    # If .zshrc exist
    if [ -f ~/.zshrc ]; then
        echo ".zshrc already exist"
        if question "Do you want to delete it?"; then
            rm ~/.zshrc
            ln -s $DOTDIR/zshrc ~/.zshrc
        fi
    else
        ln -s $DOTDIR/zshrc ~/.zshrc
    fi

    # If .oh-my-zsh exist
    if [ -d ~/.oh-my-zsh/custom ]; then
        echo ".oh-my-zsh/custom already exist."
        if question "Do you want to delete it?"; then
            rm -rf ~/.oh-my-zsh/custom
            ln -s $DOTDIR/custom ~/.oh-my-zsh/custom
        fi
    else
        ln -s $DOTDIR/custom ~/.oh-my-zsh/custom
    fi
fi

# Replace tmux.conf
if question "Do you want to install tmux.conf?"; then
    # If tmux.conf exist
    if [ -f ~/.tmux.conf ];then
        echo ".tmux.conf already exist"
        if question "Do you want to delete it?"; then
            rm ~/.tmux.conf
            ln -s $DOTDIR/tmux.conf ~/.tmux.conf
        fi
    else
        ln -s $DOTDIR/tmux.conf ~/.tmux.conf
    fi
fi

# Replace tern-config (tern.js global config)
if question "Do you want to install .tern-config?"; then
    if npm list|grep tern-jquery-extension > /dev/null; then
        # If tern-config exist
        if [ -f ~/.tern-config ]; then
            echo ".tern-config already exist"
            if question "Do you want to delete if?"; then
                rm ~/.tern-config
                ln -s $DOTDIR/tern-config ~/.tern-config
            fi
        else
            ln -s $DOTDIR/tern-config ~/.tern-config
        fi
    else
        echo "tern-jquery-extension not installed.."
        echo "to install type: npm install tern-jquery-extension"
        echo "exiting.. "
        exit 1
    fi
fi
