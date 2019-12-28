#!/bin/bash

# ===== Default / Options / Flags =====
readonly HUSTLY_VERSION="0.1.0"
FLAG_i=false

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
            echo "Running (omz) install"
            ;;
        "uninstall")
            echo "Running (omz) uninstall"
            ;;
        "update")
            echo "Running (omz) update"
            ;;
        "check")
            echo "Running (omz) check"
            ;;
        *)
            echo "$1 Didn't match anything operation for OMZ"
            exit 2
    esac
}

function mod_fzf() {
    case "$1" in
        "install")
            echo "Running (fzf) install"
            ;;
        "uninstall")
            echo "Running (fzf) uninstall"
            ;;
        "update")
            echo "Running (fzf) update"
            ;;
        "check")
            echo "Running (fzf) check"
            ;;
        *)
            echo "$1 Didn't match anything operation for fzf"
            exit 2
    esac
}

function mod_tmux() {
    case "$1" in
        "install")
            echo "Running (tmux) install"
            ;;
        "uninstall")
            echo "Running (tmux) uninstall"
            ;;
        "update")
            echo "Running (tmux) update"
            ;;
        "check")
            echo "Running (tmux) check"
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
            ;;
        "uninstall")
            echo "Running (mintty) uninstall"
            ;;
        "update")
            echo "Running (mintty) update"
            ;;
        "check")
            echo "Running (mintty) check"
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
            ;;
        "uninstall")
            echo "Running (git) uninstall"
            ;;
        "update")
            echo "Running (git) update"
            ;;
        "check")
            echo "Running (git) check"
            ;;
        *)
            echo "$1 Didn't match anything operation for git"
            exit 2
    esac
}

function mod_rust() {
    case "$1" in
        "install")
            echo "Running (rust) install"
            ;;
        "uninstall")
            echo "Running (rust) uninstall"
            ;;
        "update")
            echo "Running (rust) update"
            ;;
        "check")
            echo "Running (rust) check"
            ;;
        *)
            echo "$1 Didn't match anything operation for rust"
            exit 2
    esac
}

function mod_nvim() {
    case "$1" in
        "install")
            echo "Running (nvim) install"
            ;;
        "uninstall")
            echo "Running (nvim) uninstall"
            ;;
        "update")
            echo "Running (nvim) update"
            ;;
        "check")
            echo "Running (nvim) check"
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
    parse_option_args ${@}
    parse_subcommand_args ${@}
}

function parse_subcommand_args() {
    # Ignore -i, flag
    [[ $FLAG_i == true ]] && shift;
    [[ $# == 0 ]] && print_help "Please specify an operation: install, uninstall, .."

    # Cache operation
    local operation=$1
    shift;

    mods=()
    if [[ $# == 0 ]]; then
        # All mods
        mods=${MODULES[@]}
    else
        # Check valid arguments
        for m in $@; do
            local mUpper=${m^^}
            if [ ${MODULES["$mUpper"]+x} ]; then
                mods+=(${MODULES["$mUpper"]})
            else
                print_help "Unknown module name: \"$mUpper\""
            fi
        done
    fi

    mod_all $operation ${mods[@]}
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
            "install"|"uninstall"|"update"|"check")
                return 0
                ;;
            *)
                print_help "Unknown option: \"$1\""
        esac
    done
}

function get_log() {
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
        LOGFILE="$LOGDIR/$1"
    fi
}

function mod_all() {
    local readonly operation=$1
    shift # Shift remaining arguments (array of mod_func)
    local readonly funcs=("$@")

    for func in ${funcs[@]}; do
        $func $operation
    done
}

# =============== Call main ===============
main ${@}
