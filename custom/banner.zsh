# Ignore DISPLAY, xprop error
DISPLAY_BACKUP=$DISPLAY; unset DISPLAY
screenfetch -c 8,3
DISPLAY=$DISPLAY_BACKUP; unset DISPLAY_BACKUP

echo $fg_bold[green]"# Tmux Sessions: "
echo -n $fg_bold[green]
tmux list-sessions
echo
echo $fg_bold[blue]"# Alias of the day: "
echo -n $fg_bold[blue]
alias | sed -n $[${RANDOM}%$(alias|wc -l)]p
echo -n $fg_bold[blue]
alias | sed -n $[${RANDOM}%$(alias|wc -l)]p

echo
echo $fg_bold[magenta]"# SSH-Agent: "
