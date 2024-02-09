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

# Working with UTC epoch times
function utcnow {
    if [[ "$1" == "-h" ]]; then
        date -u +"%Y-%m-%dT%H:%M:%S.%3NZ"
    else
        date -u +%s%3N
    fi
}
function minago  { date -u --date="$1 minutes ago" +%s%3N }
function hourago { date -u --date="$1 hours ago" +%s%3N }
function dayago  { date -u --date="$1 days ago" +%s%3N }
function secago  { date -u --date="$1 seconds ago" +%s%3N }

# From Human readable to utc timestamp with miliseconds
function toepoch { date -u -d "$1" +"%s%3N" }

# From UTC (with or without miliseconds) to human readable UTC
function tohuman {
    local datetime="$1"
    local show_local_time=0

    if [[ "$1" == "-l" || "$1" == "--local" ]]; then 
        local datetime="$2"
        local show_local_time=1
    elif [[ "$2" == "-l" || "$2" == "--local" ]]; then 
        show_local_time=1
    fi

    if [ "${#datetime}" -eq 13 ]; then
        # Extract milliseconds by getting the last 3 digits
        local milliseconds="${datetime: -3}"
        # Convert the timestamp to seconds for the 'date' command
        local seconds="${datetime:0:-3}"
        # Format the date, excluding milliseconds
        local formatted_date=$(date $([[ "$show_local_time" -eq 0 ]] && echo "-u") -d @"$seconds" +"%Y-%m-%dT%H:%M:%S")
        # Append milliseconds and 'Z' to match the desired format
        echo "${formatted_date}.${milliseconds}Z"
    elif [ "${#datetime}" -eq 10 ]; then
        # For 10-digit seconds timestamp, simply format without milliseconds
        date $([[ "$show_local_time" -eq 0 ]] && echo "-u") -d @"$datetime" +"%Y-%m-%dT%H:%M:%S.000Z"

    else
        echo -e "Invalid epoch time length. Should be 10 chars without and 13 chars with miliseconds"
    fi
}
