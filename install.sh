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

# Replace .gitconfig
if question "Do you want to install .gitconfig"; then
    # If .gitconfig exist
    if [ -f ~/.gitconfig ]; then
        echo ".gitconfig already exist"
        if question "Do you want to delete it?"; then
            rm ~/.gitconfig
            ln -s $DOTDIR/.gitconfig ~/.gitconfig
        fi
    else
        ln -s $DOTDIR/.gitconfig ~/.gitconfig
    fi
fi

# Replace tern-config and compile tern-for-vim (tern.js global config)
if question "Do you want to install .tern-config & compile?"; then
    if npm list|grep tern-jquery-extension > /dev/null; then
        # If tern-config exist
        if [ -f ~/.tern-config ]; then
            echo ".tern-config already exist"
            if question "Do you want to delete if?"; then
                rm ~/.tern-config
                ln -s $DOTDIR/tern-config ~/.tern-config
                cd $DOTDIR/vimfiles/bundle/tern_for_vim
                npm install
                cd $DOTDIR
            fi
        else
            ln -s $DOTDIR/tern-config ~/.tern-config
            cd $DOTDIR/vimfiles/bundle/tern_for_vim
            npm install
            cd $DOTDIR
        fi
    else
        echo "tern-jquery-extension not installed.."
        echo "to install type: npm install tern-jquery-extension"
        echo "exiting.. "
        exit 1
    fi
fi

# Compile YouCompleteMe
if question "Do you want to compile YouCompleteMe? WARNING, beta deps is not checked!"; then
    cd $DOTDIR/vimfiles/bundle/YouCompleteMe
    ycm_args="./install.py"
    # mono support
    if question "Do you want C# completion (requires mono)?"; then
        ycm_args+=' --omnisharp-completer'
    fi
    # Clang support
    if question "Do you want C/C++ completion (requires clang)?"; then
        ycm_args+=' --clang-completer'
    fi
    # Tern support
    if question "Do you want JS completion (requires tern)?"; then
        ycm_args+=' --tern-completer'
    fi
    $ycm_args
    cd $DOTDIR
fi
