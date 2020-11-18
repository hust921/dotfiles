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
