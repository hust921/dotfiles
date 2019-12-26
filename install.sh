#!/bin/bash
# script file location
readonly DOTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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
    if ! question "Are you sure you want to continue?"; then
        exit
    fi
fi

# Replace oh-my-zsh files
if question "Do you want to install oh-my-zsh files?"; then
    # If oh-my-zsh is missing -> Install it
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

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

# fzf fuzzy search
if question "Do you want to install fzf fuzzy search?"; then
    # Install if missing
    if ! [ -d ~/.fzf ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    fi

    if ! [ -f $DOTDIR/custom/fzf.zsh ]; then
        ln -s ~/.fzf.zsh $DOTDIR/custom/fzf.zsh
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

# Install TPM (Tmux Plugin Manager)
if question "Do you want to install tpm (tmux plugin manager)"; then
    # If tmux.conf exist
    if [ -d ~/.tmux/plugins ];then
        echo ".tmux/plugins already exist"
        if question "Do you want to delete it?"; then
            rm -rf ~/.tmux/plugins
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
            tmux new "~/.tmux/plugins/tpm/bin/install_plugins; exit"
        fi
    else
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        tmux new "~/.tmux/plugins/tpm/bin/install_plugins; exit"
    fi
fi

# Install minttyrc
if question "Do you want to install minttyrc (remember to set in wsl/min-tty options)"; then
    # If minttyrc exist
    if [ -f ~/.minttyrc ]; then
        echo ".minttyrc already exist"
        if question "Do you want to delete it?"; then
            rm ~/.minttyrc
            ln -s $DOTDIR/minttyrc ~/.minttyrc
        fi
    else
        ln -s $DOTDIR/minttyrc ~/.minttyrc
    fi
fi

# Replace gitconfig
if question "Do you want to install gitconfig"; then
    # If gitconfig exist
    if [ -f ~/.gitconfig ]; then
        echo ".gitconfig already exist"
        if question "Do you want to delete it?"; then
            rm ~/.gitconfig
            cp $DOTDIR/gitconfig ~/.gitconfig
        fi
    else
        cp $DOTDIR/gitconfig ~/.gitconfig
    fi
fi

# Install rust, racer & src code (for deoplete, neovim)
if question "Do you want to install rust? (+ vim dep)"; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rustup toolchain install nightly && \
    rustup default nightly && \
        rustup component add rls rust-analysis rust-src && \
        cargo install racer && \
    rustup default stable && \
    ln -s ~/.cargo/env $DOTDIR/custom/cargo.zsh
fi

# Install nvim
if question "Do you want to install nvim?"; then
    sudo add-apt-repository -y ppa:neovim-ppa/stable && \
    sudo apt-get update -y && \
    sudo apt-get install -y neovim python-dev python-pip python3-dev python3-pip && \
    pip3 install pynvim jedi flake8 && \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    mkdir -p ~/.config && \
    if ! [ -d ~/.config/nvim ]; then
        ln -s $DOTDIR/config/nvim ~/.config/nvim
    fi && \
    nvim +PlugInstall +qall
fi
