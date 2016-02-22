#!/bin/zsh

function pys() {
    pyversion=$(python -c 'import sys; print sys.version_info.major')
    if [[ $pyversion -eq "2" ]]; then
        python -m SimpleHTTPServer 8000 &
    else
        python -m http.server 8000 &
    fi
    google-chrome "http://localhost:8000"
}

function phps() {
    php -S 127.0.0.1:8000 &
    google-chrome "http://localhost:8000"
}
