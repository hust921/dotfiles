#!/bin/zsh
# If not running WSL => exit
if grep -iv "microsoft" /proc/version >> /dev/null; then
    return 0
fi

# Windows Aliases
alias wi="win32yank.exe -i"
alias wo="win32yank.exe -o"
alias expl='/mnt/c/Windows/explorer.exe $(wslpath -w $(pwd))'

# Run Powershell from WSL
alias pwsh='/mnt/c/Program\ Files/PowerShell/6/pwsh.exe'
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
