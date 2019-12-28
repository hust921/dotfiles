#!/bin/bash

# ===== Default / Options / Flags =====
readonly HUSTLY_VERSION="0.1.0"
FLAG_i=false
FLAG_y=false

# ===== Global Settings / Variables =====
PARSED_ARGS=false
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

# ===== Module implementations =====
function mod_omz() {
    case "$1" in
        "INSTALL")
            echo "Running (OMZ) INSTALL"
            ;;
        "UNINSTALL")
            echo "Running (OMZ) UNINSTALL"
            ;;
        "UPDATE")
            echo "Running (OMZ) UPDATE"
            ;;
        "CHECK")
            echo "Running (OMZ) CHECK"
            ;;
        *)
            echo "$1 Didn't match anything operation for OMZ"
            exit 2
    esac
}

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
    echo -e "\t-y, --yes, --assume-yes\t\tAutomatic yes to prompts; assume \"yes\" as answer to all prompts and run non-interactively"
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
    if [[ $PARSED_ARGS == false ]]; then
        echo "Internal error! \$PARSED_ARGS was NOT set before calling main!"
        exit 1
    fi
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

# ===== Parse CommandLine arguments =====
# Requires > 0 arguments
if [[ $# -eq 0 ]];then
    print_help
fi

# parse option arguments
case "$1" in
    "-h"|"--help")
        print_help
        ;;
    "-V"|"--version")
        print_version
        ;;
    "-y"|"--yes"|"--assume-yes")
        FLAG_y=true
        shift
        ;;
    "-i"|"--interactive")
        FLAG_i=true
        shift
        ;;
    "install"|"uninstall"|"update"|"check")
        echo "NOT IMPLEMENTED!!!!"
        echo "NOT IMPLEMENTED!!!!"
        echo "NOT IMPLEMENTED!!!!"
        echo "NOT IMPLEMENTED!!!!"
        echo "NOT IMPLEMENTED!!!!"
        exit 10
        operation="$@"
        list=()
        while [[ $# > 0 ]] ; do
            list+=(${MODULES[omz]})
            list+=(${MODULES[fzf]})
            list+=(${MODULES[tmux]})
            mod_all "INSTALL" ${list[@]}
        done
        break;
        ;;
    *)
        print_help "Unknown option: \"$1\""
esac
# parse subcommand argument

# parse modules arguments

# ===== Call main =====
PARSED_ARGS=true
main
