#!/bin/bash

# ===== Default / Options / Flags =====
readonly HUSTLY_VERSION="1.0.0"
FLAG_i=false
FLAG_d=false
readonly DOTDIR="$HOME/dotfiles"

# ===== Global Settings / Variables =====
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 

declare -rgA MODULES=(
    [SYS]=mod_sys
    [OMZ]=mod_omz
    [FZF]=mod_fzf
    [TMUX]=mod_tmux
    [MINTTY]=mod_mintty
    [GIT]=mod_git
    [RUST]=mod_rust
    [NVIM]=mod_nvim
)

# ============================== ==============================
# =====               Module Implementations              =====
# ============================== ==============================
function mod_omz() {
    local plugins=$(find $DOTDIR/plugins/ -maxdepth 1 -type d -not -name plugins -exec basename {} \;) || return 1
    case "$1" in
        "install")
            dlog "=== Running (omz) install ==="
            sudo apt-get install -y zsh screenfetch || return 1
            rm -rf "$HOME/.oh-my-zsh"
            local omzscript=$(mktemp /tmp/omz-XXXXXXXX)
            if [[ -f "$omzscript" ]]; then
                rm -rf "$omzscript"
            fi
            curl -fsSL 'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh' > "$omzscript"
            chmod u+x "$omzscript"
            sh -c "yes | $omzscript" || return 1
            sudo usermod -s /bin/zsh "$(whoami)" || return 1

            rm -rf "$HOME/.zshrc"
            ln -s "$DOTDIR/zshrc" "$HOME/.zshrc" || return 1

            dlog "linking .oh-my-zsh/custom"
            rm -rf "$HOME/.oh-my-zsh/custom"
            ln -s "$DOTDIR/custom" "$HOME/.oh-my-zsh/custom" || return 1

            dlog "installing plugins"
            "$DOTDIR/plugins/install.sh" || return 1
            local newPlugins=$(find $DOTDIR/plugins/ -maxdepth 1 -type d -not -name plugins -exec basename {} \;) || return 1
            dlog "linking .oh-my-zsh/plugins: "
            for plugname in $newPlugins; do
                echo -e "$plugname, "
                ln -s "$DOTDIR/plugins/$plugname" "$HOME/.oh-my-zsh/plugins/$plugname" && \
                chmod -R go-w "$HOME/.oh-my-zsh/plugins/$plugname" || return 1
            done
            echo ""

            rm -rf "$HOME/.zcompdump*" # Remove cache

            dlog "=== Finished (omz) install ==="
            ;;
        "uninstall")
            dlog "=== Running (omz) uninstall ==="
            local currdir=$(pwd)
            cd "$HOME/.oh-my-zsh"
            rm -rf custom
            rm -rf plugins
            git reset --hard HEAD
            yes | source "tools/uninstall.sh"
            cd "$currdir"
            rm -rf "$HOME/.zshrc"
            rm -rf "$HOME/.zcompdump*" # Remove cache
            dlog "=== Finished (omz) uninstall ==="
            ;;
        "update")
            dlog "=== Running (omz) update ==="
            # Reset and update OMZ git repo
            cd "$HOME/.oh-my-zsh/"
            rm -rf custom
            rm -rf plugins
            git reset --hard HEAD
            local gitreset=$?
            cd $DOTDIR
            if [[ "$gitreset" != 0 ]]; then
                return 1
            fi

            # Update OMZ
            env ZSH="$HOME/.oh-my-zsh" /bin/sh -c '
                chmod u+x "$ZSH/tools/upgrade.sh"
                yes | "$ZSH/tools/upgrade.sh"' || return 1

            # Delete custom folder and link to dotfiles version
            if [ -d ~/.oh-my-zsh/custom ]; then
                rm -rf ~/.oh-my-zsh/custom || return 1
            fi
            ln -s $DOTDIR/custom ~/.oh-my-zsh/custom || return 1

            # Re-Linking plugins
            dlog "updating plugins"
            "$DOTDIR/plugins/install.sh"
            dlog "linking .oh-my-zsh/plugins: "
            for plugname in $plugins; do
                echo -e "$plugname, "
                ln -s "$DOTDIR/plugins/$plugname" "$HOME/.oh-my-zsh/plugins/$plugname" || return 1
            done
            echo ""

            rm -rf "$HOME/.zcompdump*" # Remove cache
            dlog "=== Finished (omz) update ==="
            ;;
        "check")
            dlog "=== Running (omz) check ==="
            checklink "$HOME/.zshrc" "$DOTDIR/zshrc" && \
            checklink "$HOME/.oh-my-zsh/custom" "$DOTDIR/custom" && \
            echo $SHELL | grep -i 'zsh' >> /dev/null || return 1

            for plugname in $plugins; do
                checklink "$HOME/.oh-my-zsh/plugins/$plugname" "$DOTDIR/plugins/$plugname" || return 1
            done
            ;;
        *)
            echo "$1 Didn't match anything operation for OMZ"
            exit 2
    esac
}

function mod_sys() {
    case "$1" in
        "install")
            dlog "=== Running (sys) install ==="
            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] Installing fd-find. WARNING! using static .deb url. deprecated"
            install_deb 'https://github.com/sharkdp/fd/releases/download/v7.5.0/fd-musl_7.5.0_amd64.deb' || return 1

            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] Installing ripgrep. WARNING! using static .deb url. deprecated"
            install_deb 'https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb' || return 1

            dlog "Installing ag, the silver searcher"
            sudo apt-get install -y silversearcher-ag || return 1

            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] Installing bat (cat alternative). WARNING! using static .deb url. deprecated"
            install_deb 'https://github.com/sharkdp/bat/releases/download/v0.13.0/bat-musl_0.13.0_amd64.deb' || return 1

            dlog "Installing jq (json processor)"
            sudo apt-get install -y jq || return 1

            dlog "Installing xq (xml processor)"
            sudo curl -o /usr/local/bin/xq 'https://github.com/maiha/xq.cr/releases' && \
            sudo chmod 751 /usr/local/bin/xq || return 1

            dlog "Installing xmllint"
            sudo apt install -y libxml2-utils

            dlog "=== Finished (sys) install ==="
            ;;
        "uninstall")
            dlog "=== Running (sys) uninstall ==="

            dlog "Uninstalling fd-find"
            sudo dpkg --purge --force-all fd-find || return 1

            dlog "Uninstalling ripgrep"
            sudo dpkg --purge --force-all ripgrep || return 1

            dlog "Uninstalling ag, the silver searcher"
            sudo apt-get --purge remove -y silversearcher-ag || return 1

            dlog "Uninstalling bat (cat alternative)"
            sudo dpkg --purge --force-all bat || return 1

            dlog "Uninstalling jq (json processor)"
            sudo apt-get --purge remove -y jq || return 1

            dlog "Uninstalling xq (xml processor)"
            sudo rm -rf /usr/local/bin/xq

            dlog "Uninstalling xmllint"
            sudo apt-get --purge remove -y libxml2-utils || return 1

            dlog "=== Finished (sys) uninstall ==="
            ;;
        "update")
            dlog "=== Running (sys) update ==="

            dlog "Updating fd-find"
            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] fd-find is installed using a staic link to a .deb package. Can't do update."

            dlog "Updating ripgrep"
            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] ripgrep is installed using a staic link to a .deb package. Can't do update."

            dlog "Updating ag, the silver searcher"
            sudo apt-get upgrade -y silversearcher-ag || return 1

            dlog "Updating bat (cat alternative)"
            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] fd-find is installed using a staic link to a .deb package. Can't do update."

            dlog "Updating jq (json processor)"
            sudo apt-get upgrade -y jq || return 1

            dlog "Updating xq (xml processor)"
            echo -e "[\e[40m\e[33mWARNING\e[49m\e[39m] xq is installed using a staic link to a .deb package. Can't do update"

            dlog "Updating xmllint"
            sudo apt-get upgrade -y libxml2-utils || return 1

            dlog "=== Finished (sys) update ==="
            ;;
        "check")
            which fd && \
            which rg && \
            which ag && \
            which bat && \
            which jq && \
            which xq && \
            which xmllint || return 1
            ;;
        *)
            echo "$1 Didn't match anything operation for SYS"
            exit 2
    esac
}

function mod_fzf() {
    case "$1" in
        "install")
            dlog "=== Running (fzf) install ==="
            if ! [ -d "$HOME/.fzf" ]; then
                git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" || return 1
                "$HOME/.fzf/install" --key-bindings --completion || return 1
            fi
            dlog "=== Finished (fzf) install ==="
            ;;
        "uninstall")
            dlog "=== Running (fzf) uninstall ==="
            "$HOME/.fzf/uninstall" || return 1
            dlog "=== Finished (fzf) uninstall ==="
            ;;
        "update")
            dlog "=== Running (fzf) update ==="
            tempdirfzf="$(pwd)"
            cd "$HOME/.fzf" && git pull && ./install --key-bindings --completion || return 1
            cd "$tempdirfzf" || return 1
            dlog "=== Finished (fzf) update ==="
            ;;
        "check")
            dlog "=== Running (fzf) check ==="
            command -v "$HOME/.fzf/bin/fzf"
            ;;
        *)
            echo "$1 Didn't match anything operation for fzf"
            exit 2
    esac
}

function mod_tmux() {
    case "$1" in
        "install")
            dlog "=== Running (tmux) install ==="
            sudo apt install -y tmux || return 1
            if [ -f ~/.tmux.conf ]; then
                rm ~/.tmux.conf || return 1
            fi
            ln -s "$DOTDIR/tmux.conf" ~/.tmux.conf || return 1
            dlog "=== Finished (tmux) install ==="
            ;;
        "uninstall")
            dlog "=== Running (tmux) uninstall ==="
            if [ -f ~/.tmux.conf ]; then
                rm ~/.tmux.conf || return 1
            fi
            sudo apt --purge remove -y tmux || return 1
            dlog "=== Finished (tmux) uninstall ==="
            ;;
        "update")
            dlog "=== Running (tmux) update ==="
            sudo apt update -y && sudo apt upgrade -y tmux || return 1
            dlog "=== Finished (tmux) update ==="
            ;;
        "check")
            dlog "=== Running (tmux) check ===" && \
            checklink "$HOME/.tmux.conf" "$DOTDIR/tmux.conf"
            ;;
        *)
            echo "$1 Didn't match anything operation for tmux"
            exit 2
    esac
}

function mod_mintty() {
    # Skip if not running WSL
    if grep -iv "microsoft" /proc/version >> /dev/null; then
        return 0
    fi

    case "$1" in
        "install")
            dlog "=== Running (mintty) install ==="
            if [ -f ~/.minttyrc ]; then
                rm ~/.minttyrc
            fi
            ln -s "$DOTDIR/minttyrc" "$HOME/.minttyrc"
            dlog "=== Finished (mintty) install ==="
            ;;
        "uninstall")
            dlog "=== Running (mintty) uninstall ==="
            rm -rf "$HOME/.minttyrc"
            dlog "=== Finished (mintty) uninstall ==="
            ;;
        "update")
            dlog "=== Running (mintty) update ==="
            dlog "=== Finished (mintty) update ==="
            ;;
        "check")
            dlog "=== Running (mintty) check ==="
            checklink "$HOME/.minttyrc" "$DOTDIR/minttyrc"
            ;;
        *)
            echo "$1 Didn't match anything operation for mintty"
            exit 2
    esac
}

function mod_git() {
    case "$1" in
        "install")
            dlog "=== Running (git) install ==="
            if ! [ -x "$(command -v add-apt-repository -h)" ]; then
                sudo apt-get update -y && sudo apt-get install -y software-properties-common || return 1
            fi
            sudo apt-add-repository -y ppa:git-core/ppa && \
            sudo apt-get update -y && \
            sudo apt-get install -y git || return 1

            if [ -f "$HOME/.gitconfig" ]; then
                rm "$HOME/.gitconfig" || return 1
            fi
            cp "$DOTDIR/gitconfig" "$HOME/.gitconfig" || return 1
            dlog "=== Finished (git) install ==="
            ;;
        "uninstall")
            dlog "=== Running (git) uninstall ==="
            rm -rf "$HOME/.gitconfig" || return 1
            dlog "=== Finished (git) uninstall ==="
            ;;
        "update")
            dlog "=== Running (git) update ==="
            sudo apt-get upgrade -y git || return 1
            dlog "=== Finished (git) update ==="
            ;;
        "check")
            dlog "=== Running (git) check ===" && \
            git --version >> /dev/null
            ;;
        *)
            echo "$1 Didn't match anything operation for git"
            exit 2
    esac
}

function mod_rust() {
    case "$1" in
        "install")
            dlog "=== Running (rust) install ==="
            dlog "installing rustup"
            (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y) || return 1
            dlog "setting rust env in path (install only)"
            source "$HOME/.cargo/env" || return 1
            dlog "installing rustfmt (for formatting)"
            rustup component add rustfmt || return 1
            dlog "installing clippy (for semantic linting)"
            rustup component add clippy || return 1
            dlog "installing rls (Rust Language Server) & rust-src"
            rustup component add rls rust-analysis rust-src || return 1
            dlog "installing rust-analyzer"
            sudo curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux -o /usr/local/bin/rust-analyzer && \
            sudo chmod 751 /usr/local/bin/rust-analyzer
            dlog "=== Finished (rust) install ==="
            ;;
        "uninstall")
            dlog "=== Running (rust) uninstall ==="
            source "$HOME/.cargo/env" || return 1
            echo 'y' | rustup self uninstall || return 1
            dlog "=== Finished (rust) uninstall ==="
            ;;
        "update")
            dlog "=== Running (rust) update ==="
            source "$HOME/.cargo/env" || return 1
            rustup self update && \
            rustup update stable && \
            rustup update nightly && \
            dlog "=== Finished (rust) update ==="
            ;;
        "check")
            dlog "=== Running (rust) check ==="
            source "$HOME/.cargo/env" || return 1
            if rustup --version && cargo --version; then
                if rust-analyzer --version; then
                    dlog "=== Finished (rust) check ==="
                    return 0
                fi
                echo "ERROR checking rust-analyzer (usr/local/bin/rust-analyzer)"
                return 1
            else
                echo "ERROR checking rustup & cargo version."
                dlog "=== Finished (rust) check ==="
                return 1;
            fi
            ;;
        *)
            echo "$1 Didn't match anything operation for rust"
            exit 2
    esac
}

function mod_nvim() {
    case "$1" in
        "install")
            dlog "=== Running (nvim) install ==="

            if ! [ -x "$(command -v add-apt-repository -h)" ]; then
                dlog "Installing software-properties-common (add-apt-repository command)"
                sudo apt-get install -y software-properties-common || return 1
            fi
            
            dlog "Installing apt-get deps"
            sudo apt-get install -y python3 python3-dev python3-pip shellcheck && \
            dlog "Installing pip3 deps" && \
            pip3 install python-language-server pynvim jedi flake8 && \
            dlog "Installing vim language server" && \
            sudo npm install -g vim-language-server && \

            dlog "Installing Nightly NeoVim"
            sudo apt-get install -y software-properties-common && \
            sudo add-apt-repository -y ppa:neovim-ppa/unstable && \
            sudo apt-get update -y && \
            sudo apt-get install -y neovim || return 1

            dlog "Downloading and installing vim-plug" && \
            curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
            dlog "Making $HOME/.config directory" && \
            mkdir -p "$HOME/.config" || return 1

            if ! [ -d "$HOME/.config/nvim" ]; then
                ln -s "$DOTDIR/config/nvim" "$HOME/.config/nvim" || return 1
            fi

            dlog "Installing Neovim Plugins"
            /usr/bin/nvim +PlugInstall +UpdateRemotePlugins +qall || return 1
            dlog "=== Finished (nvim) install ==="
            ;;
        "uninstall")
            dlog "=== Running (nvim) uninstall ==="
            sudo apt-get --purge remove -y neovim && \
            dlog "Uninstalling pynvim (pip3)" && \
            pip3 uninstall -y pynvim && \
            dlog "Deleting nvim config directories" && \
            rm -rf "$HOME/.local/share/nvim" && \
            rm -rf "$HOME/.config/nvim" && \
            dlog "=== Finished (nvim) uninstall ==="
            ;;
        "update")
            dlog "=== Running (nvim) update ==="
            dlog "Upgrading apt-get deps" && \
            sudo apt-get upgrade -y python-dev python-pip python3-dev python3-pip neovim shellcheck && \
            dlog "Installing pynvim, jedi & flake8 (pip3)" && \
            pip3 install --upgrade pynvim jedi flake8 && \
            dlog "Installing nvim plugins" && \
            /usr/bin/nvim +PlugUpgrade +PlugUpdate +UpdateRemotePlugins +qall && \
            dlog "=== Finished (nvim) update ==="
            ;;
        "check")
            dlog "=== Running (nvim) check ==="
            checklink "$HOME/.config/nvim" "$DOTDIR/config/nvim" && \
            /usr/bin/nvim --version
            ;;
        *)
            echo "$1 Didn't match anything operation for nvim"
            exit 2
    esac
}

# ============================== ==============================
# =====               hustly Implementation               =====
# ============================== ==============================
# ===== Arguments parsing / Help-text =====
function print_help() {

cat << "EOF"
   .       .    *  .   .   .   .       .     .  _  .    ,   _   _ .  ,  .    .
 *   ,  .                          *      .    | |_ _ _ ___| |_| |_ _
   .       .   ,   *     .   *  .    .      .  |   | | |_ -|  _| | | |.    .  .
.      .          ___  .           .     *   . |_|_|___|___|_| |_|_  |         
    *          __/_  `.  .-"""-.                                 |___|  .    . 
.       *    . \_,` | \-'  /   )`-')    *    .        *    .                  
     .   ,      "") `"`    \  ((`"`  .    .              .       .  .    .    *
  .         .  ___Y  ,    .'7 /|               .  *   ,       .                
     *   .    (_,___/...-` (_/_/  hustly.sh               .      *         *  .
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
EOF

    echo -e ""
    echo -e ""
    echo -e "USAGE:"
    echo -e "\thustly [OPTIONS] [SUBCOMMAND] [MODULE..]"
    echo -e "\tNo module(s) implies operation on ALL available modules"
    echo -e ""
    echo -e "OPTIONS:"
    echo -e "\t-h, --help\t\tShow a short usage summary"
    echo -e "\t-i, --interactive\tInteractive [yN] installation"
    echo -e "\t-d, --debug\t\tMore verbose debugging info"
    echo -e "\t-V, --version\t\tPrint version information"
    echo -e ""
    echo -e "SUBCOMMANDS:"
    echo -e "\tinstall\t\tinstall module(s)"
    echo -e "\tuninstall\tuninstall module(s)"
    echo -e "\tupdate\t\tupdate modules(s)"
    echo -e "\tcheck\t\tconfirm installation for module(s)"
    echo -e ""
    echo -e "MODULES:"
    echo -e "\tOMZ\t\tZsh, zshrc scipts, Oh-My-Zsh and plugins"
    echo -e "\tFZF\t\tFuzzy finder for shell & vim"
    echo -e "\tTMUX\t\tTerminal Multiplexer, setup and plugin manager (tpm)"
    echo -e "\tMINTTY\t\tWSLTTY / MINTTY Setup. Mainly color corrections"
    echo -e "\tGIT\t\tGit config and setup"
    echo -e "\tRUST\t\tRust Stable & Nightly environment"
    echo -e "\tNVIM\t\tNeoVim setup with vim-plug"
    echo -e ""
    echo -e "DOCS"
    echo -e "\tVersion\t\t$HUSTLY_VERSION stable"
    echo -e "\tAurthor\t\tMorten Lund"
    echo -e "\tRepository\thttps://github.com/hust921/dotfiles"
    echo -e ""

    # Print error message if provided
    if [[ $# -eq 1 ]]; then
        echo -e "\e[30m\e[101m[ERROR] $1\e[49m\e[39m"
        exit 3
    fi

    exit 0
}

function print_version() {
    echo $HUSTLY_VERSION
    exit 0
}

# ===== Module Operations / Helpers =====
function main() {
    check_os_info
    parse_option_args "${@}"
    parse_subcommand_args "${@}"
}

function check_os_info() {
    OS_DISTRO="$(temp_lowercase=$(sed -rn 's/^ID=([a-zA-Z]+)/\1/p' /etc/os-release); echo ${temp_lowercase^^})"
    OS_VERSION="$(sed -rn 's/VERSION_ID=\"([0-9\.]+)\"/\1/p' /etc/os-release)"

    if [[ "$OS_DISTRO" != "UBUNTU" ]] && [[ "$OS_DISTRO" != "DEBIAN" ]]; then
        print_help "Unknown linux distro: \"$OS_DISTRO\". Only Ubuntu & Debian Supported."
    fi
}

function parse_subcommand_args() {
    # Ignore -i, -d, flags <-- fix this later
    [[ $FLAG_i == true ]] && shift;
    [[ $FLAG_d == true ]] && shift;
    [[ $# == 0 ]] && print_help "Please specify an operation: install, uninstall, .."

    dlog "Args: ${*}"

    # Cache operation
    local operation=$1
    shift;

    dlog "operation: $operation"
    dlog "modules (before): ${*}"

    mods=()
    if [[ $# == 0 ]]; then
        # All mods
        mods=${!MODULES[*]}
        dlog "mods=all ${mods[*]}"
    else
        # Check valid arguments
        for m in "$@"; do
            local mUpper=${m^^}
            if [ ${MODULES["$mUpper"]+x} ]; then
                mods+=("$mUpper")
            else
                print_help "Unknown module name: \"$mUpper\""
            fi
        done
    fi

    dlog "mods = ${mods[*]}"

    mod_all "$operation" "${mods[@]}"
}

function parse_option_args() {
    if [[ $# -eq 0 ]];then
        print_help
    fi

    # parse option arguments
    for i in "$@"; do
        case "$i" in
            "-h"|"--help")
                print_help
                ;;
            "-V"|"--version")
                print_version
                ;;
            "-i"|"--interactive")
                FLAG_i=true
                shift;
                ;;
            "-d"|"--debug")
                FLAG_d=true
                shift;
                ;;
            "install"|"uninstall"|"update"|"check")
                return 0
                ;;
            *)
                print_help "Unknown option: \"$1\""
        esac
    done
}

# Ask a Y/N question
function question {
    echo "$1"
    ret=1
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) ret=0; break;;
            No  ) ret=1; break;;
        esac
    done

    return $ret
}

# Check if link: exist, is link, points to correct file
function checklink {
    from=$(readlink -ef "$1")
    to=$(readlink -ef "$2")

    echo "Expected: ($1) -> ($2)    |    Actual: $from -> $to"
    [[ "$1" != "$2" ]] && [[ "$from" == "$to" ]]
}

function install_deb() {
    TEMP_DEB="$(mktemp).deb" && \
    curl -fsSL -o "$TEMP_DEB" "$1" && \
    sudo dpkg -i "$TEMP_DEB" && \
    rm -f "$TEMP_DEB" || return 1
}

function get_log() {
    if [ $FLAG_d = true ]; then
        LOGFILE="/dev/stdout"
        return 0
    fi

    if [ -z ${LOGDIR+x} ]; then
        LOGDIR=$(mktemp -d -t hustly-XXXXXXXXXX)
    fi

    # if $1 is not defined
    if [ -z ${1+x} ]; then
        # if $LOGFILE is defined => undefine
        if ! [ -z ${LOGFILE+x} ]; then
            unset LOGFILE
        fi
    else
        LOGFILE="$LOGDIR/$1.log"
    fi
}

function dlog() {
    if [[ $FLAG_d == true ]]; then
        echo -e "[${FUNCNAME[1]}]: $*"
    fi
}

function mod_all() {
    dlog "args: $*"
    local readonly operation=$1
    exitcode=0
    shift # Shift remaining arguments (array of mod_func)
    local readonly moduleKeys=("$*")

    for key in ${moduleKeys[@]}; do
        # if interactive and cancelled (NO) by user => continue
        if [[ $FLAG_i == true ]] && ! question "Do you want to $operation module: $key"; then
            continue
        else
            get_log "$key"
            dlog "Key=$key"
            dlog "MODULES[Key]=${MODULES[$key]}"
            
            # Run MODULE+Operation && print SUCCESS
            # Or print FAILURE
            if ${MODULES[$key]} $operation > $LOGFILE 2>&1; then
                echo -e "[\e[32mSUCCESS\e[49m\e[39m] [$key] [${operation^^}] Log: $LOGFILE"
            else
                exitcode=99
                echo -e "[\e[31mFAILURE\e[49m\e[39m] [$key] [${operation^^}] Log: $LOGFILE"
            fi
        fi
    done

    if [[ $exitcode != 0 ]]; then
        exit 99
    fi
}

# =============== Call main ===============
cd "$DOTDIR"
main "${@}"
