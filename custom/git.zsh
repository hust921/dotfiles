#!/bin/zsh

# Modified standard aliases
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'\'' --all'
alias gba='git branch -avv'
alias grso='git remote show origin'

# `git reset (--hard) HEAD` alias overrides, with confirmation
unalias grh
function grh() {
    read "answer?Are you sure you want to do: git reset --mixed HEAD? [y/N]: "
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        git reset HEAD "$@"
    fi
}

unalias grhh
function grhh() {
    read "answer?Are you sure you want to do: git reset --hard HEAD? [y/N]: "
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        git reset --hard HEAD "$@"
    fi
}

function git_branch_fuzzy_search() {
    git rev-parse HEAD > /dev/null 2>&1 &&
        git branch -a -vv --color=always | grep -v '/HEAD\s' |
        fzf --ansi --multi --tac | sed 's/^..//' | awk '{print $1}' |
        sed 's#^remotes/[^/]*/##'
}
bindkey -s '^g' '"$(git_branch_fuzzy_search)"^M'
