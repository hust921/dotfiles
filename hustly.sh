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
declare -rgA MODULES=(
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
    case "$1" in
        "install")
            echo "=== Running (omz) install ==="
            sudo apt-get install -y zsh screenfetch
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            ln -s "$DOTDIR/zshrc" "$HOME/.zshrc"
            ln -s "$DOTDIR/custom" "$HOME/.oh-my-zsh/custom"
            echo "=== Finished (omz) install ==="
            return 0
            ;;
        "uninstall")
            echo "=== Running (omz) uninstall ==="
            rm -rf "$HOME/.oh-my-zsh/custom"
            source "$HOME/.oh-my-zsh/tools/uninstall.sh"
            echo "=== Finished (omz) uninstall ==="
            return 0
            ;;
        "update")
            echo "=== Running (omz) update ==="
            sudo apt-get upgrade -y zsh screenfetch
            "$DOTDIR/update_oh_my_zsh.sh"
            echo "=== Finished (omz) update ==="
            return 0
            ;;
        "check")
            echo "=== Running (omz) check ==="
            env | grep -i '.oh-my-zsh'
            ;;
        *)
            echo "$1 Didn't match anything operation for OMZ"
            exit 2
    esac
}

function mod_fzf() {
    case "$1" in
        "install")
            echo "=== Running (fzf) install ==="
            if ! [ -d "$HOME/.fzf" ]; then
                git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
                "$HOME/.fzf/install"
            fi

            if ! [ -f "$DOTDIR/custom/fzf.zsh" ]; then
                ln -s "$HOME/.fzf.zsh" "$DOTDIR/custom/fzf.zsh"
            fi
            echo "=== Finished (fzf) install ==="
            return 0
            ;;
        "uninstall")
            echo "=== Running (fzf) uninstall ==="
            rm -rf "$DOTDIR/custom/fzf.zsh"
            "$HOME/.fzf/uninstall"
            echo "=== Finished (fzf) uninstall ==="
            return 0
            ;;
        "update")
            echo "=== Running (fzf) update ==="
            tempdirfzf="$(pwd)"
            cd "$HOME/.fzf" && git pull && ./install
            cd "$tempdirfzf"
            echo "=== Finished (fzf) update ==="
            return 0
            ;;
        "check")
            echo "=== Running (fzf) check ==="
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
            echo "=== Running (tmux) install ==="
            sudo apt install -y tmux
            if [ -f ~/.tmux.conf ]; then
                rm ~/.tmux.conf
            fi
            ln -s "$DOTDIR/tmux.conf" ~/.tmux.conf
            echo "=== Finished (tmux) install ==="
            return 0
            ;;
        "uninstall")
            echo "=== Running (tmux) uninstall ==="
            if [ -f ~/.tmux.conf ]; then
                rm ~/.tmux.conf
            fi
            sudo apt --purge remove -y tmux
            echo "=== Finished (tmux) uninstall ==="
            return 0
            ;;
        "update")
            echo "=== Running (tmux) update ==="
            sudo apt update -y && sudo apt upgrade -y tmux
            echo "=== Finished (tmux) update ==="
            return 0
            ;;
        "check")
            echo "=== Running (tmux) check ==="
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
            echo "Running (mintty) install"
            return 1
            ;;
        "uninstall")
            echo "Running (mintty) uninstall"
            return 1
            ;;
        "update")
            echo "Running (mintty) update"
            return 1
            ;;
        "check")
            echo "Running (mintty) check"
            return 1
            ;;
        *)
            echo "$1 Didn't match anything operation for mintty"
            exit 2
    esac
}

function mod_git() {
    case "$1" in
        "install")
            echo "Running (git) install"
            return 1
            ;;
        "uninstall")
            echo "Running (git) uninstall"
            return 1
            ;;
        "update")
            echo "Running (git) update"
            return 1
            ;;
        "check")
            echo "Running (git) check"
            return 1
            ;;
        *)
            echo "$1 Didn't match anything operation for git"
            exit 2
    esac
}

function mod_rust() {
    case "$1" in
        "install")
            echo "=== Running (rust) install ==="
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            source "$HOME/.cargo/env"
            rustup toolchain install nightly && \
            rustup default nightly && \
                rustup component add rls rust-analysis rust-src && \
                cargo install racer && \
            rustup default stable

            if ! [ -f ~/.cargo/env ]; then
                ln -s ~/.cargo/env "$DOTDIR/custom/cargo.zsh"
            fi
            echo "=== Finished (rust) install ==="
            return 0
            ;;
        "uninstall")
            echo "=== Running (rust) uninstall ==="
            rustup uninstall stable
            rustup uninstall nightly
            rustup self uninstall
            echo "=== Finished (rust) uninstall ==="
            return 0
            ;;
        "update")
            echo "=== Running (rust) update ==="
            rustup self update
            rustup update stable
            rustup update nightly
            echo "=== Finished (rust) update ==="
            return 0
            ;;
        "check")
            echo "=== Running (rust) check ==="
            if rustup --version && cargo --version; then
                echo "=== Finished (rust) check ==="
                return 0
            else
                echo "ERROR checking rustup & cargo version."
                echo "rustup version: $(rustup --version)"
                echo "cargo version: $(cargo --version)"
                echo "=== Finished (rust) check ==="
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
            echo "=== Running (nvim) install ==="
            sudo add-apt-repository -y ppa:neovim-ppa/stable && \
            sudo apt-get update -y && \
            sudo apt-get install -y neovim python-dev python-pip python3-dev python3-pip && \
            pip3 install pynvim jedi flake8 && \
            curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
            mkdir -p "$HOME/.config" && \
            if ! [ -d "$HOME/.config/nvim" ]; then
                ln -s "$DOTDIR/config/nvim" "$HOME/.config/nvim"
            fi && \
            nvim +PlugInstall +qall
            echo "=== Finished (nvim) install ==="
            return 0
            ;;
        "uninstall")
            echo "=== Running (nvim) uninstall ==="
            sudo apt-get remove --purge neovim
            pip3 uninstall pynvim
            rm -rf "$HOME/.local/share/nvim"
            rm -rf "$HOME/.config/nvim"
            echo "=== Finished (nvim) uninstall ==="
            return 0
            ;;
        "update")
            echo "=== Running (nvim) update ==="
            sudo apt-get upgrade -y neovim python-dev python-pip python3-dev python3-pip
            pip3 install --upgrade pynvim jedi flake8
            nvim +PlugUpgrade +qall
            nvim +PlugUpdate +qall
            echo "=== Finished (nvim) update ==="
            return 0
            ;;
        "check")
            echo "=== Running (nvim) check ==="
            checklink "$HOME/.config/nvim" "$DOTDIR/.config/nvim"
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
                mods+=$mUpper
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
    if [ $FLAG_d ]; then
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
