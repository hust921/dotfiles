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
plugins=(autoswitch_virtualenv zsh-autopair git git-flow dirhistory command-not-found colored-man-pages rust zsh-syntax-highlighting zsh-autosuggestions zsh-completions jq python pip fzf uv globalias)

# User configuration
export PATH=".:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:$HOME/.local/bin"
export EDITOR='nvim'

# Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Local config. Logins / Creds / Etc
[ -f ~/.zshlocal.zsh ] && source ~/.zshlocal.zsh
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# cdhist
if type cdhist &>/dev/null; then
    . <(cdhist -i)
fi

# Only refresh compinit once a day
## completion stuff
zstyle ':compinstall' filename '$HOME/.zshrc'

zcachedir="$HOME/.zcache"
[[ -d "$zcachedir" ]] || mkdir -p "$zcachedir"

autoload -Uz compinit
compinit

# ZSH Profiling
[[ "$ZPROF" = true ]] && zprof || return 0
