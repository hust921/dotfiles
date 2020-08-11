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
plugins=(git git-flow dirhistory command-not-found colored-man-pages cargo fd ripgrep rust zsh-syntax-highlighting zsh-autosuggestions zsh-completions)

# User configuration
export PATH=".:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.local/bin"
export EDITOR='nvim'

# Set Pager
command -v bat &> /dev/null && export PAGER=bat || export PAGER='less -F -X'

# Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Start ssh-agent
eval $(ssh-agent) &> /dev/null

# Man pages -> Read in vim
if command -v nvim &> /dev/null; then
    export MANPAGER='nvim -c "set ft=man|normal gO" -'
fi

# Local config. Logins / Creds / Etc
[ -f ~/.zshlocal.zsh ] && source ~/.zshlocal.zsh
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
