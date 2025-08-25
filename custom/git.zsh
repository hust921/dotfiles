#!/bin/zsh

# Modified standard aliases
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'\'' --all'
alias gba='git branch -avv'
alias grso='git remote show origin'
alias gcd='git checkout develop'
alias gclean='git clean -xdfi'
alias gcm='git checkout master'
alias gaaa='git add --all'

git_add_all_not_secrets() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "gadd: not inside a git repo" >&2
    return 1
  }
  git -C "$root" add -A \
        ':(glob,exclude)**/appsettings*.json' \
        ':(exclude)appsettings*.json' \
        "$@"
}
alias gaa='git_add_all_not_secrets'

# Assume `gd HEAD` if no args is given to `gd`
unalias gd
function gd() {
    if [ $# -eq 0 ]; then
        git diff HEAD
    else
        git diff "$@"
    fi
}


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
    local result=($(git rev-parse HEAD > /dev/null 2>&1 &&
        git branch -a -vv --color=always | grep -v '/HEAD\s' |
        fzf --ansi --multi --tac | sed 's/^..//' | awk '{print $1}' |
        sed 's#^remotes/[^/]*/##'))
    LBUFFER="${LBUFFER}${(q)result}"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle -N git_branch_fuzzy_search
bindkey '^g' git_branch_fuzzy_search
