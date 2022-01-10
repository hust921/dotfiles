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

# DockerClean all containers & delete images
if [ -x "$(command -v docker)" ]; then
    dockerclean()
    {
        docker stop $(docker ps -a -q);
        docker rm $(docker ps -a -q);
        docker rmi $(docker images -q)
    }
fi

passgen() {
    # eval 'wi'
    # the wi alias is set in: linuxtools.zsh OR wsltools.zsh
    if [ "$#" -eq 1 ] && [ "$1" -ge 0 ] 2>/dev/null; then
        local plen="$(($1 - 1))"
        tr -cd '[:alnum:]' < /dev/urandom | fold -w"$plen" | head -n1 | tr -d '\n' | eval 'wi'
        echo "Password of length: $1 copied to clipboard" 
    else
        echo "Functions only takes a possitive integer as argument!"
        echo "eg: passgen 10"
    fi
}

# Enforce safe file editing practice
function sudo() {
    if [[ $1 == "$EDITOR" ]] || [[ $1 == "vi" ]] || [[ $1 == "vim" ]] || [[ $1 == "nvim" ]]; then
        echo ""
        echo "\tStop using \"sudo $1\" ya twit!"
        echo "\tUse sudoedit <file> or sudo -e <file>"
        echo ""
        return 1
    else
        command /usr/bin/sudo "$@"
    fi
}

# Just / Justfile aliases
if [ -x $(command -v just) ]; then
    alias  j='just'
    alias jl='just --list'
    alias jr='just run'
    alias jb='just build'
    alias jt='just test'
    alias jc='just clean'
fi

# Cargo aliases
if [ -x $(command -v cargo) ]; then
    alias cr='cargo run'
    alias ct='cargo test'
    alias cb='cargo build'
    alias cc='cargo check'
fi
