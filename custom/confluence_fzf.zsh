#!/usr/bin/env zsh

export CONFLUENCE_FZF_CACHE_FILE="$HOME/.cache/confluencefzf/cache"

function con {
    local serverfile="$HOME/.config/confluencefzf/server"
    if [ -f "$serverfile" ]
    then
        # Update cache
        check_confluence_cache

        # FZF Select
        local selected_page=$(cat "$CONFLUENCE_FZF_CACHE_FILE" | fzf --no-hscroll +m | cut -d '|' -f 2- | tr -d '[:space:]')
        [ -z "$selected_page" ] && return 0
        local server=$(cat "$serverfile")
        local selected_page="$server""/wiki""$selected_page"
        xdg-open "$selected_page"
    else
        echo "No Confluence server file found (server: \"$serverfile\")"
        return 2
    fi
}

function update_confluence_cache {
    local serverfile="$HOME/.config/confluencefzf/server"
    local credfile="$HOME/.config/confluencefzf/creds"
    # Authentication
    if [ -f "$credfile" ] && [ -f "$serverfile" ]
    then
        # Cache file
        local cache_dir=$(dirname "$CONFLUENCE_FZF_CACHE_FILE")
        [ -d "$cache_dir" ] || mkdir -p "$cache_dir"
        truncate -s 0 "$CONFLUENCE_FZF_CACHE_FILE"

        # Print / Echo json
        local apikey=$(cat "$credfile")
        local server=$(cat "$serverfile")
        local paging=0

        echo "Updating Confluence cache file: $CONFLUENCE_FZF_CACHE_FILE"
        while ((paging % 1000 == 0)) ; do
            local result=$(curl -Sslk -X GET "$server/wiki/rest/api/content?type=page&limit=1000&start=$paging" -H  "accept: application/json" -u "$apikey")
            local pagesize=$(echo "$result" | jq '.size')
            local paging=$((paging + pagesize))

            echo "$result" |jq '.results[] | "\(.title) | \(._links.webui)"' | sed -e 's/"//g' >> "$CONFLUENCE_FZF_CACHE_FILE"
            sort -o "$CONFLUENCE_FZF_CACHE_FILE" "$CONFLUENCE_FZF_CACHE_FILE"
        done
    else
        echo "No Confluence creditials and/or server file found: (cred: \"$credfile\", server: \"$serverfile\")"
        return 1
    fi
}


function check_confluence_cache {
    # If cache file (dont exist or) was modified more than 60mins ago (1 hours) => Update cache
    [ -f "$CONFLUENCE_FZF_CACHE_FILE" ] || (update_confluence_cache; return 0)
    [[ $(find "$CONFLUENCE_FZF_CACHE_FILE" -mmin +60 -print) ]] && update_confluence_cache
}
