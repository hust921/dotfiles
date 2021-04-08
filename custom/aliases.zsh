# Global (fixes)
alias hist="fc -lE -200"
alias tmux="tmux -2"

# ls aliases
alias exa='exa --icons -h --color=always'
alias ls='exa'
alias l1='command ls -1'
alias ll='exa -lg --git'
alias la='ll -a'

# xclip
alias xc="xclip -selection c"

# dsize: Show the size of all files in current directory
alias dsize="/bin/ls -R -l |awk 'BEGIN {sum=0} {sum+=\$5} END {print sum}' |numfmt --to=iec-i"

# Search running processes
alias psa="ps aux |grep"

# Download video
alias Video-Download 'youtube-dl --format "best" --prefer-ffmpeg -o "%(title)s.%(ext)s"'

alias mysql='mycli'
alias vim='nvim'
alias vi='nvim'
alias grep='grep --color=always'
alias less='less -R'

# Docker
if [ -x "$(command -v docker)" ]; then
# DockerClean all containers & delete images
    dockerclean()
    {
        docker system prune -a --force --filter "label!=pruneme=false"
        docker stop $(docker ps -a -q);
        docker rm $(docker ps -a -q);
    }

    dockerlabel()
    {
        echo
        echo 'echo "FROM archlinux:base-devel" | docker build --label pruneme="false" -t "archlinux:base-devel" -'
        echo
    }
fi
