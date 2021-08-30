#!/usr/bin/env zsh

function tc {
    # Authentication
    credfile="$HOME/.config/teamcityfzf/creds"
    serverfile="$HOME/.config/teamcityfzf/server"
    if [ -f "$credfile" ] && [ -f $serverfile ]; then
        tctoken="$(cat $credfile)"
        server="$(cat $serverfile)"

        # Get projects list
        projects=$(curl -Sskl -H "Accept: application/json" -H "Authorization: Bearer $tctoken" "$server/app/rest/projects" | jq '.project[] | "\(.name) | \(.webUrl)"' | sed -e 's/"//g' | sort -f)

        # Run FZF and launch browser
        selectedProj=$(echo $projects | fzf --no-hscroll +m | cut -d '|' -f 2- | tr -d '[:space:]')
        [ -z "$selectedProj" ] && return 0
        xdg-open "$selectedProj"
    else
        echo "No TeamCity creditials/server file found"
        exit 1
    fi
}
