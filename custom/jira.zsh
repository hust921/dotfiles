#!/usr/bin/env zsh
export JIRA_FZF_CACHE_FILE_DIR="$HOME/.cache/jirafzf"
export JIRA_FZF_CACHE_FILE_TEAM="$HOME/.cache/jirafzf/team"
export JIRA_FZF_CACHE_FILE_ALL="$HOME/.cache/jirafzf/all"
export JIRA_FZF_CACHE_FILE_MINE="$HOME/.cache/jirafzf/mine"

function fzf_jira {
  # FZF Select
  local ticket=$(cat "$1" | fzf --no-hscroll +m | cut -d ':' -f 1)
  [ -z "$ticket" ] && return 0

  [ ${#ticket} -gt 0 ] && xdg-open "https://$JIRA_ORG.atlassian.net/browse/$ticket"
}

function check_jira_cache {
  # If cache file (dont exist or) was modified more than 60mins ago (1 hours) => Update cache
  [ -f "$1" ] || update_jira_cache $1 $2; return 0
  [[ $(find "$1" -mmin +60 -print) ]] && update_jira_cache $1 $2
}

# $1 => Cache file
# $2 => Jira Query
function update_jira_cache {
  local credfile="$HOME/.config/jirafzf/creds"

  # Authentication
  if [ -f "$credfile" ]; then
    # Cache files
    [ -d "$JIRA_FZF_CACHE_FILE_DIR" ] || mkdir -p "$JIRA_FZF_CACHE_FILE_DIR"
    truncate -s 0 "$1"

    # Download and update cache file
    source "$credfile"

    # Update Cache
    local bg_pids=""
    for ((page=0;page<5;page++)); do
      jira_query $2 $page >> "$1"
      bg_pids="$bg_pids $!"
    done

    wait $bg_pids
    sort -o "$1" "$1"
  else
    echo "No Jira creditials file found: $credfile"
    return 1
  fi
}

function jira_query() {
  curl "https://$JIRA_ORG.atlassian.net/rest/api/2/search?jql=$1&maxResults=100&startAt=$(($2 * 100))" \
    -s -u "$JIRA_USER:$JIRA_TOKEN" \
    |  jq -r '.issues[] | "\(.key): \(.fields.summary)"'
}

# Aliases & Functions
#function fzf_jira_git() {
function fjh() {
  echo ''
  echo -e 'fj\033[47m\033[30mh\033[0m => Show this help'
  echo -e 'fj  => Default to fj\033[47m\033[30mt\033[0m'
  echo ''
  echo -e 'fj\033[47m\033[30mt\033[0m => Project = '$JIRA_TEAM' & Status != Done'
  echo -e 'fj\033[47m\033[30ma\033[0m => All issues'
  echo -e 'fj\033[47m\033[30mm\033[0m => Mine assignee = currentUser()'
  echo -e 'fj\033[47m\033[30mg\033[0m => git feature/project-ticket-randomother-naming => jira/project-ticket'
  echo ''
}

#function fzf_jira_team() {
function fj() {
  check_jira_cache "$JIRA_FZF_CACHE_FILE_TEAM" "project%20%3D%20$JIRA_TEAM%20AND%20status%20!%3D%20Done%20order%20by%20updated%20DESC"
  fzf_jira "$JIRA_FZF_CACHE_FILE_TEAM"
}

#function fzf_jira_all() {
function fja() {
  check_jira_cache "$JIRA_FZF_CACHE_FILE_ALL" 'order%20by%20updated%20DESC'
  fzf_jira "$JIRA_FZF_CACHE_FILE_ALL"
}

#function fzf_jira_mine() {
function fjm() {
  check_jira_cache "$JIRA_FZF_CACHE_FILE_MINE" 'assignee%20%3D%20currentUser()%20AND%20resolution%20%3D%20Unresolved%20order%20by%20updated%20DESC'
  fzf_jira "$JIRA_FZF_CACHE_FILE_MINE"
}

#function fzf_jira_git() {
function fjg() {
  local ticket=$(git rev-parse --abbrev-ref HEAD | command grep -oP '[a-zA-Z0-9]+-\d{2,4}')
  xdg-open "https://$JIRA_ORG.atlassian.net/browse/$ticket"
}
