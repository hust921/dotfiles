#!/bin/bash

set -o errexit   # to cause script to exit if any line fails
set -o nounset   # to cause an error if you use an empty variable
set -o noclobber # the '>' symbol not allowed to overwrite "existing" files
set -o pipefail  # cmd_a | cmd_b . Fails if cmd_a doesn't cleanly exit (0) 

# ===== Global Settings / Variables =====
readonly HUSTLY_VERSION="0.1.0"
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
    echo "dotfiles installer & maintenance utilities $HUSTLY_VERSION"
    echo "Morten Lund <https://github.com/hust921/dotfiles>"
    echo ""
    echo "USAGE:"
    echo "\thustly [OPTIONS] [SUBCOMMAND] [MODULE..]"
    echo "\t\tNo module(s) implies operation on ALL available modules"
    echo ""
    echo "OPTIONS:"
    echo "\t-h, --help\tShow a short usage summary"
    echo "\t-i, --interactive\tInteractive [yN] installation"
    echo "\t-y, --yes, --assume-yes\tAutomatic yes to prompts; assume \"yes\" as answer to all prompts and run non-interactively"
    echo "\t-o, --output <file>\tWrite output to <file> instead of stdout & stderr"
    echo "\t-V, --version\tPrint version information and exit successfully"
    echo ""
    echo "SUBCOMMANDS:"
    echo "\tinstall\t"
    echo "\tuninstall\t"
    echo "\tupdate\t"
    echo "\tcheck\t"
    echo "\t\t"
    echo ""
    echo "MODULES:"
    echo "\tOMZ\tZsh, zshrc scipts, Oh-My-Zsh and plugins"
    echo "\tFZF\tFuzzy finder for shell & vim"
    echo "\tTMUX\tTerminal Multiplexer, setup and plugin manager (tpm)"
    echo "\tMINTTY\tWSLTTY / MINTTY Setup. Mainly color corrections"
    echo "\tGIT\tGit config and setup"
    echo "\tRUST\tRust Stable,Nightly environment for build, tests and vim plugins"
    echo "\tNVIM\tNeoVim setup with vim-plug"
    echo ""
    exit 0
}

# ===== Module Operations / Helpers =====
function main() {
    sample_argument_parsed
}

function mod_all() {
    local readonly operation=$1
    shift # Shift remaining arguments (array of mod_func)
    local readonly funcs=("$@")

    for func in ${funcs[@]}; do
        $func $operation
    done
}

function sample_argument_parsed() {
    list=()
    list+=(${MODULES[omz]})
    list+=(${MODULES[fzf]})
    list+=(${MODULES[tmux]})
    mod_all "INSTALL" ${list[@]}
}

main
