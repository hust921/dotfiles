#!/bin/bash

# ===== Global Settings / Variables =====
declare -rgA MODULES=(
    [omz]=mod_omz
    [fzf]=mod_fzf
    [tmux]=mod_tmux
    [mintty]=mod_mintty
    [git]=mod_git
    [rust]=mod_rust
    [nvim]=mod_nvim
)

# ===== Module implementations =====
function mod_omz() {
    case "$1" in
        "INSTALL")
            echo "Running (ZSH) INSTALL"
            ;;
        "UNINSTALL")
            echo "Running (ZSH) UNINSTALL"
            ;;
        "UPDATE")
            echo "Running (ZSH) UPDATE"
            ;;
        "CHECK")
            echo "Running (ZSH) CHECK"
            ;;
        *)
            echo "$1 Didn't match anything operation for ZSH"
            exit 2
    esac
}

# ===== Arguments parsing / Help-text =====
function print_help() {
    echo "PRINT HELP TEXT HERE!"
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
