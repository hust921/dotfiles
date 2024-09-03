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
plugins=(autoswitch_virtualenv zsh-autopair git git-flow dirhistory command-not-found colored-man-pages rust zsh-syntax-highlighting zsh-autosuggestions zsh-completions jq)

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

# jq plugin
bindkey '^j' jq-complete

echo "
+------------------------------------------------------------+--------------------------------------------------------------------+-------------------+
|                    Bash/Zsh Keybindings                    |                             TOOLS                                  |      csvkit       |
+------------------+-----------------------------------------+--------------------------------------------------------------------+-------------------+
| Key Combination  | Description                             |                     View: csvlens                                  | Input             |
+------------------+-----------------------------------------+                                                                    +-------------------+
| Ctrl + U         | Clear the text before the cursor        |                     venv: autoswitch_virtualenv                    |    in2csv         |
| Ctrl + K         | Clear the text after the cursor         |                        mkvenv                                      |    sql2csv        |
| Ctrl + Y         | Yank (paste) the last cut/deleted       |                        mkvenv --python=/usr/bin/python2            +-------------------+
+------------------+-----------------------------------------+                        rmvenv                                      | Processing        |
| Ctrl + B         | Move the cursor back one character      |                                                                    +-------------------+
| Alt  + B         | Move the cursor back one word           |                                                                    |    csvclean       |
| Ctrl + F         | Move the cursor forward one character   |                                                                    |    csvcut         |
| Alt  + F         | Move the cursor forward one word        |                                                                    |    csvgrep        |
+------------------+-----------------------------------------+                                                                    |    csvjoin        |
| Ctrl + W         | Delete the word before the cursor       |                                                                    |    csvsort        |
| Ctrl + H         | Delete the character before the cursor  |                                                                    |    csvstack       |
| Ctrl + D         | Delete the character after the cursor   |                                                                    +-------------------+
| Alt  + D         | Delete the word after the cursor        |                                                                    | Output & Analysis |
+------------------+-----------------------------------------+                                                                    +-------------------+
+------------------+-----------------------------------------+                                                                    |    csvformat      |
| Ctrl + P         | Recall the previous command             |                                                                    |    csvjson        |
| Ctrl + N         | Recall the next command                 |                                                                    |    csvlook        |
+------------------+-----------------------------------------+                                                                    |    csvpy          |
| Alt  + K         | Kafka Topic FZF                         |                                                                    |    csvsql         |
| Ctrl + Z         | CD History                              |                                                                    |    csvstat        |
| Ctrl + X         | Easy-Motion                             |                                                                    +-------------------+
| Ctrl + J         | jq REPL                                 |
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
