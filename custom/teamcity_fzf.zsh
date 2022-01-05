#!/usr/bin/env zsh

function tc {
    # Authentication
    local credfile="$HOME/.config/teamcityfzf/creds"
    local serverfile="$HOME/.config/teamcityfzf/server"
    if [ -f "$credfile" ] && [ -f $serverfile ]; then
        local tctoken="$(cat $credfile)"
        local server="$(cat $serverfile)"

        # Get projects list
        local projects=$(curl -Sskl -H "Accept: application/json" -H "Authorization: Bearer $tctoken" "$server/app/rest/projects" | jq '.project[] | if (.archived == null or .archived == false) then . else empty end | "\(.name) | \(.webUrl)"' | sed -e 's/"//g' | sort -f)

        # Run FZF and launch browser
        local selectedProj=$(echo $projects | fzf --no-hscroll +m | cut -d '|' -f 2- | tr -d '[:space:]')
        [ -z "$selectedProj" ] && return 0
        xdg-open "$selectedProj"
    else
        echo "No TeamCity creditials/server file found"
        return 1
    fi
}
