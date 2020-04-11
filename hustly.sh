#!/bin/bash

# ===== Default / Options / Flags =====
readonly HUSTLY_VERSION="0.1.0"
FLAG_i=false
FLAG_d=false
readonly DOTDIR="$HOME/dotfiles"

# ===== Global stacktrace =====
# https://gist.github.com/ahendrix/7030300
function errexit() {
  local err=$?
  set +o xtrace
  local code="${1:-1}"
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $err"
  # Print out the stack trace described by $function_stack  
  if [ ${#FUNCNAME[@]} -gt 2 ]
  then
    echo "Call tree:"
    for ((i=1;i<${#FUNCNAME[@]}-1;i++))
    do
      echo " $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
    done
  fi
  echo "Exiting with status ${code}"
  exit "${code}"
}

trap 'errexit' ERR
set -o errtrace

# ===== Global Settings / Variables =====
set -o errexit   # to cause script to exit if any line fails
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 

# Check if running WSL
if grep -i "microsoft" /proc/version >> /dev/null; then
    declare -rgA MODULES=(
        [OMZ]=mod_omz
        [FZF]=mod_fzf
        [TMUX]=mod_tmux
        [MINTTY]=mod_mintty
        [GIT]=mod_git
        [RUST]=mod_rust
        [NVIM]=mod_nvim
    )
else
    declare -rgA MODULES=(
        [OMZ]=mod_omz
        [FZF]=mod_fzf
        [TMUX]=mod_tmux
        [GIT]=mod_git
        [RUST]=mod_rust
        [NVIM]=mod_nvim
    )
fi

# ============================== ==============================
# =====               Module Implementations              =====
# ============================== ==============================
function mod_omz() {
    case "$1" in
        "install")
            dlog "=== Running (omz) install ==="
            sudo apt-get install -y zsh screenfetch || return 1
            rm -rf "$HOME/.oh-my-zsh"
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || return 1
            sudo usermod -s /bin/zsh "$(whoami)" || return 1

            rm -rf "$HOME/.zshrc"
            ln -s "$DOTDIR/zshrc" "$HOME/.zshrc" || return 1

            rm -rf "$HOME/.oh-my-zsh/custom"
            ln -s "$DOTDIR/custom" "$HOME/.oh-my-zsh/custom" || return 1

            dlog "=== Finished (omz) install ==="
            ;;
        "uninstall")
            dlog "=== Running (omz) uninstall ==="
            rm -rf "$HOME/.oh-my-zsh/custom"
            source "$HOME/.oh-my-zsh/tools/uninstall.sh" || return 1
            rm -rf "$HOME/.zshrc"
            dlog "=== Finished (omz) uninstall ==="
            ;;
        "update")
            dlog "=== Running (omz) update ==="
            "$DOTDIR/update_oh_my_zsh.sh" || return 1
            dlog "=== Finished (omz) update ==="
            ;;
        "check")
            dlog "=== Running (omz) check ==="
            checklink "$DOTDIR/zshrc" "$HOME/.zshrc" && \
            checklink "$DOTDIR/custom" "$HOME/.oh-my-zsh/custom" && \
            echo $SHELL | grep -i 'zsh' >> /dev/null
            ;;
        *)
            echo "$1 Didn't match anything operation for OMZ"
            exit 2
    esac
}

function mod_fzf() {
    case "$1" in
        "install")
            dlog "=== Running (fzf) install ==="
            if ! [ -d "$HOME/.fzf" ]; then
                git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" || return 1
                "$HOME/.fzf/install" || return 1
            fi

            if ! [ -f "$DOTDIR/custom/fzf.zsh" ]; then
                ln -s "$HOME/.fzf.zsh" "$DOTDIR/custom/fzf.zsh" || return 1
            fi
            dlog "=== Finished (fzf) install ==="
            ;;
        "uninstall")
            dlog "=== Running (fzf) uninstall ==="
            rm -rf "$DOTDIR/custom/fzf.zsh" || return 1
            "$HOME/.fzf/uninstall" || return 1
            dlog "=== Finished (fzf) uninstall ==="
            ;;
        "update")
            dlog "=== Running (fzf) update ==="
            tempdirfzf="$(pwd)"
            cd "$HOME/.fzf" && git pull && ./install || return 1
            cd "$tempdirfzf" || return 1
            dlog "=== Finished (fzf) update ==="
            ;;
        "check")
            dlog "=== Running (fzf) check ===" && \
            checklink "$DOTDIR/custom/fzf.zsh" "$HOME/.fzf.zsh"
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
                sudo apt-get install -y software-properties-common || return 1
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
            sudo chmod 755 /usr/local/bin/rust-analyzer

            if ! [ -f ~/.cargo/env ]; then
                ln -s ~/.cargo/env "$DOTDIR/custom/cargo.zsh" || return 1
            fi
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
            dlog "Installing apt-get deps"
            sudo apt-get install -y python-dev python-pip python3-dev python3-pip && \
            dlog "Installing pip3 deps" && \
            pip3 install pynvim jedi flake8 && \
            dlog "Downloading nvim appimage" && \
            sudo curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o /usr/local/bin/nvim && \
            dlog "chmod'ing appimage" && \
            sudo chmod 755 /usr/local/bin/nvim && \
            dlog "Downloading and installing vim-plug" && \
            curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
            dlog "Making $HOME/.config directory" && \
            mkdir -p "$HOME/.config" || return 1

            if ! [ -d "$HOME/.config/nvim" ]; then
                ln -s "$DOTDIR/config/nvim" "$HOME/.config/nvim" || return 1
            fi

            dlog "Installing Neovim Plugins. Using (legacy) unpack for installation"
            /usr/local/bin/nvim --appimage-extract-and-run +PlugInstall +UpdateRemotePlugins +qall || return 1
            dlog "=== Finished (nvim) install ==="
            ;;
        "uninstall")
            dlog "=== Running (nvim) uninstall ==="
            dlog "Deleting nvim appimage" && \
            sudo rm -rf /usr/local/bin/nvim && \
            dlog "Uninstalling pynvim (pip3)" && \
            pip3 uninstall -y pynvim && \
            dlog "Deleting nvim config directories" && \
            rm -rf "$HOME/.local/share/nvim" && \
            rm -rf "$HOME/.config/nvim" && \
            dlog "=== Finished (nvim) uninstall ==="
            ;;
        "update")
            dlog "=== Running (nvim) update ==="
            dlog "Deleting nvim appimage" && \
            sudo rm -rf /usr/local/bin/nvim && \
            dlog "Upgrading apt-get deps" && \
            sudo apt-get upgrade -y python-dev python-pip python3-dev python3-pip && \
            dlog "Installing pynvim, jedi & flake8 (pip3)" && \
            pip3 install --upgrade pynvim jedi flake8 && \
            dlog "Downloading nvim appimage" && \
            sudo curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o /usr/local/bin/nvim && \
            dlog "chmod'ing appimage" && \
            sudo chmod 755 /usr/local/bin/nvim && \
            dlog "Installing nvim plugins" && \
            nvim --appimage-extract-and-run +PlugUpgrade +PlugUpdate +UpdateRemotePlugins +qall && \
            dlog "=== Finished (nvim) update ==="
            ;;
        "check")
            dlog "=== Running (nvim) check ==="
            checklink "$HOME/.config/nvim" "$DOTDIR/config/nvim" && \
            nvim --appimage-extract-and-run --version
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
    echo -e "dotfiles installer & maintenance utilities $HUSTLY_VERSION"
    echo -e "Morten Lund <https://github.com/hust921/dotfiles>"
    echo -e ""
    echo -e "USAGE:"
    echo -e "\thustly [OPTIONS] [SUBCOMMAND] [MODULE..]"
    echo -e "\t\tNo module(s) implies operation on ALL available modules"
    echo -e ""
    echo -e "OPTIONS:"
    echo -e "\t-h, --help\t\t\tShow a short usage summary"
    echo -e "\t-i, --interactive\t\tInteractive [yN] installation"
    echo -e "\t-d, --debug\t\t\tMore verbose debugging info"
    echo -e "\t-V, --version\t\t\tPrint version information and exit successfully"
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
    echo -e "\tRUST\t\tRust Stable,Nightly environment for build, tests and vim plugins"
    echo -e "\tNVIM\t\tNeoVim setup with vim-plug"
    echo -e ""

    # Print error message if provided
    if [[ $# -eq 1 ]]; then
        echo -e "\e[30m\e[101m[ERROR] $1\e[49m\e[39m"
    fi

    exit 0
}

function print_version() {
    echo $HUSTLY_VERSION
    exit 0
}

# ===== Module Operations / Helpers =====
function main() {
    parse_option_args "${@}"
    parse_subcommand_args "${@}"
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
    src=$(readlink -ef "$1")
    target=$(readlink -ef "$2")

    if [[ "$src" == "$target" ]]; then
        dlog "File ($1) $src links to ($2) $target"
        return 0;
    else
        echo "File ($1) $src did not link to ($2) $target"
        return 1;
    fi
    #return [ -L "$1" ] && [ $(readlink -e "$1") == "$2"]
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
            (${MODULES[$key]} $operation > $LOGFILE 2>&1 \
                && echo -e "[\e[32mSUCCESS\e[49m\e[39m] [$key] [${operation^^}] Log: $LOGFILE") \
            || echo -e "[\e[31mFAILURE\e[49m\e[39m] [$key] [${operation^^}] Log: $LOGFILE"

        fi
    done
}

# =============== Call main ===============
main "${@}"
