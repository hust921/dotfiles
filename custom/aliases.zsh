# Global (fixes)
alias hist="fc -lE -200"
alias tmux="tmux -2"

# ls aliases
alias la="ls -lAFh"
alias ll="ls -lFh"
alias l1="ls -1"

# xclip
alias xc="xclip -selection c"

# dsize: Show the size of all files in current directory
alias dsize="/bin/ls -R -l |awk 'BEGIN {sum=0} {sum+=\$5} END {print sum}' |numfmt --to=iec-i"

# Search running processes
alias psa="ps aux |grep"

# Git
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset'\'' --all'

# Download video
alias Video-Download 'youtube-dl --format "best" --prefer-ffmpeg -o "%(title)s.%(ext)s"'

alias mysql='mycli'
alias vim='nvim'
alias vi='nvim'
