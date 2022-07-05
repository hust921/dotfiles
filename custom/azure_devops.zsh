#!/usr/bin/env zsh

export AZURE_REPOS_CACHE_FILE="$HOME/.cache/azurefzf/reposcache"

function repo {
    if which az >> /dev/null; then
        local selectedRepo=$(cat ~/.cache/azurefzf/reposcache | fzf --no-hscroll +m | cut -d ':' -f 2- | tr -d '[:space:]')
        [ -z "$selectedRepo" ] && return 0
        xdg-open "$selectedRepo"
    else
        echo "Azure cli not installed"
        return 1
    fi
}

function update_azure_repos_cache() {
    # Delete (Old) & Create new cache file
    local cache_dir="$(dirname $AZURE_REPOS_CACHE_FILE)"
    [ -d "$cache_dir" ] || mkdir -p "$cache_dir"
    truncate -s 0 "$AZURE_REPOS_CACHE_FILE"

    # Get Azure devops Project names
    declare -a local projects=($(az devops project list | jq '.value[].id' | sed -e 's/"//g'))

    # Iterate projects & get git repos names+urls
    for proj in ${projects[@]}; do
        az repos list -p "$proj" | jq -r '.[]  | "\(.name): \(.webUrl)"' >> "$AZURE_REPOS_CACHE_FILE"
    done

    sort -o "$AZURE_REPOS_CACHE_FILE" "$AZURE_REPOS_CACHE_FILE"
}

function check_azure_repos_cache() {
    if which az >> /dev/null; then
        # If cache file (dont exist or) was modified more than 360mins ago (6 hours) => Update cache
        [ -f "$AZURE_REPOS_CACHE_FILE" ] || (update_azure_repos_cache &; return 0)
        [[ $(find "$AZURE_REPOS_CACHE_FILE" -mmin +360 -print) ]] && update_azure_repos_cache &
    fi
}

check_azure_repos_cache
