# ZSH Profiling
[[ "$ZPROF" = true ]] && zmodload zsh/zprof
profzsh() {
  shell=${1-$SHELL}
  ZPROF=true $shell -i -c exit
}

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Theme
ZSH_THEME="agnoster2"

# Completion settings
HYPHEN_INSENSITIVE="true"
setopt auto_cd
setopt menu_complete

# History settings
HIST_STAMPS="dd/mm/yyyy"
HISTSIZE=1000
HISTSAVE=1000

# Plugins
plugins=(git git-flow dirhistory command-not-found colored-man-pages fd ripgrep rust zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

# User configuration
export PATH=".:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.local/bin"
export EDITOR='nvim'

# Set Pager
command -v bat &> /dev/null && export PAGER=bat || export PAGER='less -F -X'
command -v git &> /dev/null && git config --global core.pager "$PAGER"

# Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Local config. Logins / Creds / Etc
[ -f ~/.zshlocal.zsh ] && source ~/.zshlocal.zsh
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

echo "
+------------------------------------------------------------+
|                    Bash/Zsh Keybindings                    |
+------------------+-----------------------------------------+
| Key Combination  | Description                             |
+------------------+-----------------------------------------+
| Ctrl + U         | Clear the text before the cursor        |
| Ctrl + K         | Clear the text after the cursor         |
| Ctrl + Y         | Yank (paste) the last cut/deleted       |
+------------------+-----------------------------------------+
| Ctrl + B         | Move the cursor back one character      |
| Alt  + B         | Move the cursor back one word           |
| Ctrl + F         | Move the cursor forward one character   |
| Alt  + F         | Move the cursor forward one word        |
+------------------+-----------------------------------------+
| Ctrl + W         | Delete the word before the cursor       |
| Ctrl + H         | Delete the character before the cursor  |
| Ctrl + D         | Delete the character after the cursor   |
| Alt  + D         | Delete the word after the cursor        |
+------------------+-----------------------------------------+
+------------------+-----------------------------------------+
| Ctrl + P         | Recall the previous command             |
| Ctrl + N         | Recall the next command                 |
+------------------+-----------------------------------------+
| Alt  + K         | Kafka Topic FZF                         |
| Ctrl + Z         | CD History                              |
| Ctrl + X         | Easy-Motion                             |
+------------------+-----------------------------------------+
" 

# cdhist
if type cdhist &>/dev/null; then
    . <(cdhist -i)
fi

# Only refresh compinit once a day
## completion stuff
zstyle ':compinstall' filename '$HOME/.zshrc'

zcachedir="$HOME/.zcache"
[[ -d "$zcachedir" ]] || mkdir -p "$zcachedir"

_update_zcomp() {
    setopt local_options
    setopt extendedglob
    autoload -Uz compinit
    local zcompf="$1/zcompdump"
    # use a separate file to determine when to regenerate, as compinit doesn't
    # always need to modify the compdump
    local zcompf_a="${zcompf}.augur"

    if [[ -e "$zcompf_a" && -f "$zcompf_a"(#qN.md-1) ]]; then
        compinit -C -d "$zcompf"
    else
        compinit -d "$zcompf"
        touch "$zcompf_a"
    fi
    # if zcompdump exists (and is non-zero), and is older than the .zwc file,
    # then regenerate
    if [[ -s "$zcompf" && (! -s "${zcompf}.zwc" || "$zcompf" -nt "${zcompf}.zwc") ]]; then
        # since file is mapped, it might be mapped right now (current shells), so
        # rename it then make a new one
        [[ -e "$zcompf.zwc" ]] && mv -f "$zcompf.zwc" "$zcompf.zwc.old"
        # compile it mapped, so multiple shells can share it (total mem reduction)
        # run in background
        zcompile -M "$zcompf" &!
    fi
}
_update_zcomp "$zcachedir"
unfunction _update_zcomp

# ZSH Profiling
[[ "$ZPROF" = true ]] && zprof || return 0
