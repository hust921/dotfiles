#!/usr/bin/env zsh

function oc () {
        credfile="$HOME/.config/octopusfzf/creds"
        serverfile="$HOME/.config/octopusfzf/server"
        if [ -f "$credfile" ] && [ -f $serverfile ]
        then
                apikey="$(cat $credfile)"
                server="$(cat $serverfile)"
                projects=$(curl -Sslk -X GET "$server/api/projects/all" -H  "accept: application/json" -H "X-Octopus-ApiKey: $apikey" | jq '.[] | "\(.Name) | \(.Links.Web)"' | sed -e 's/"//g')
                selectedProj=$(echo $projects | fzf --no-hscroll +m | cut -d '|' -f 2- | tr -d '[:space:]')
                [ -z "$selectedProj" ] && return 0
                xdg-open "$server$selectedProj"
        else
                echo "No Octopus creditials file found: (cred: \"$credfile\", server: \"$serverfile\")"
                exit 1
        fi
}
