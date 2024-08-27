#!/bin/zsh

function cd_history_fuzzy_search() {
    trap 'return 1' SIGINT

    local result=$(cdhist -p && cat ~/.cd_history |
        sort |
        fzf --ansi --multi --tac)

    # Reset the trap to default behavior
    trap - SIGINT

    # Exit silently if result is empty
    if [[ -z "$result" ]]; then
        return 0
    fi

    # If the result is not empty and is a valid directory
    if [[ -d "$result" ]]; then
        # Prepend "cd " and append a space to the current buffer
        LBUFFER+="cd ${(q)result}"
        # Execute the command by simulating an "Enter" keypress
        zle accept-line
    else
        echo "Invalid directory: $result"
    fi
}

# Register the function as a zle widget
zle -N cd_history_fuzzy_search

# Bind the function to the desired key (Ctrl+Z in this case)
bindkey '^Z' cd_history_fuzzy_search
