#!/bin/zsh
# If fzf and fd-find do not exist => exit
! [ -f "$HOME/.fzf.zsh" ] && return 0
! [ -f "$HOME/.cargo/bin/fd" ] && return 0

# Use fd-find as FZF engine
export FZF_DEFAULT_COMMAND='fd --type file --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type directory --color=always -d 1 -L'
export FZF_DEFAULT_OPTS="--ansi"

# Control + backspace to delete whole word
bindkey '^H' backward-kill-word
# Control + arrows to navigate whole words
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey '^u' undo # Undo usinc C-u
bindkey '^[e' kill-line # Delete from cursor to end of line
bindkey '^[w' kill-region # Delete from cursor to start of line
