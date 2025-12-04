#!/bin/zsh
# If not running WSL => exit
if grep -iv "microsoft" /proc/version >> /dev/null; then
    return 0
fi

# Windows Aliases
alias wi="win32yank.exe -i"
alias wo="win32yank.exe -o"
alias expl='/mnt/c/Windows/explorer.exe $(wslpath -w "$(pwd)")'
alias start='/mnt/c/Windows/System32/cmd.exe /c start'

# Run Powershell from WSL
alias pwsh='/mnt/c/Program\ Files/PowerShell/7/pwsh.exe'
powershell()
{
    if [[ $# -eq 0 ]];then
        pwsh
    else
        winpath="$(wslpath -w "$1")"
        echo "wslpath: $winpath"
        pwsh -noexit -command "cd $winpath"
    fi
}
# pwsh="$(command ls -1 '/mnt/c/Program Files/Powershell2' &> /dev/null && find '/mnt/c/Program Files/Powershell' -iname '*pwsh.exe' |head -n1)"

sln()
{
    set local startcmd
    start='/mnt/c/Windows/System32/cmd.exe /c start'

    set local gitroot
    gitroot="$(git rev-parse --show-toplevel)"

    set local slnfile
    slnfile="$(fd '\.sln$' $gitroot)"

    set local lines
    lines=$(echo "$slnfile" | wc -l)

    set local final
    if [[ $lines -eq 1 ]]; then
        final=$(printf '%s\' "$start \"$(wslpath -w $slnfile)\"")
        bash -c "$final"
    else
        slnfile=$(echo "$slnfile" | fzf)
        final=$(printf '%s\' "$start \"$(wslpath -w $slnfile)\"")
        bash -c "$final"
    fi
}

# Expand alias (once) on Ctrl-Space
expand-now() { zle _expand_alias || zle .expand-word }  # alias first, then normal expansion
zle -N expand-now
bindkey -M emacs '^@' expand-now

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
bindkey -M emacs '^[^@' expand-aliases-line 2>/dev/null
