#!/bin/zsh
# If running WSL => exit
if grep -i "microsoft" /proc/version >> /dev/null; then
    return 0
fi

# xclip Aliases
alias wi="xclip -selection clipboard"
alias wo="xclip -selection clipboard -o"

# File navigation
expl()
{
    if [[ $# -eq 0 ]];then
        xdg-open "$(pwd)"
    else
        xdg-open $@
    fi

}

# Expand alias (once) on Ctrl-Space
expand-now() { zle _expand_alias || zle .expand-word }  # alias first, then normal expansion
zle -N expand-now
bindkey -M emacs '^ ' expand-now

# Recursively expand alias on Ctrl-Meta-Space
expand-aliases-line() {
  unset 'functions[_ea]'
  functions[_ea]=$BUFFER
  if (( $+functions[_ea] )); then
    BUFFER=${functions[_ea]#$'\t'}
    CURSOR=$#BUFFER
  fi
}
# NOTE: Not all terminals send Meta+Ctrl+Space
zle -N expand-aliases-line
bindkey -M emacs '\e^ ' expand-aliases-line 2>/dev/null
