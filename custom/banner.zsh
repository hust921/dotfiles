banner="                                                                                                                                         +------------------+-----------------------------------------+
                                                                                                                                         | Ctrl + B         | Move the cursor back one character      |
                                                                                                                                         | Alt  + B         | Move the cursor back one word           |
                                                                     +------------------+-----------------------------------------+      | Ctrl + F         | Move the cursor forward one character   |
 +------------------+-----------------------------------------+      | Ctrl + P         | Recall the previous command             |      | Alt  + F         | Move the cursor forward one word        |
 | Alt  + K         | Kafka Topic FZF                         |      | Ctrl + N         | Recall the next command                 |      +------------------+-----------------------------------------+
 | Ctrl + Z         | CD History                              |      +------------------+-----------------------------------------+      | Ctrl + W         | Delete the word before the cursor       |
 | Ctrl + X         | Easy-Motion                             |      | Ctrl + U         | Clear the text before the cursor        |      | Ctrl + H         | Delete the character before the cursor  |
 | Alt  + J         | jq REPL                                 |      | Ctrl + K         | Clear the text after the cursor         |      | Ctrl + D         | Delete the character after the cursor   |
 | Alt  + A         | ASN IP Lookup                           |      | Ctrl + Y         | Yank (paste) the last cut/deleted       |      | Alt  + D         | Delete the word after the cursor        |
 +------------------+-----------------------------------------+      +------------------+-----------------------------------------+      +------------------+-----------------------------------------+

 <<EOF   here-doc with    expansion                                  <() process as file                                                 < stdin
 <<'EOF' here-doc without expansion

 ls *.(py|sh|bash)             List all (.py OR .sh OR .bash)                                                                            lsd            List Directories
 cat <(find ~) <(find .)       Concat cmd outputs                                                                                        lls/lsscript   List All script files: (py|sh|bash|zsh|lua|ps1)
 join -t, <(sort -t, -k1 a.csv) <(sort -t, -k1 b.csv)                                                                                    lld/lsdata     List All data files:   (csv|txt|json)
 paste <(cut -f1 a.tsv) <(cut -f2 b.tsv)                                                                                                 lln/lsnew      List All new files:    changed-within 2 days
"


print_cheatsheet_banner()
{
   clear;echo "$banner"

   # Only reset if using keybinding
   if [ -z $1 ]; then
       zle reset-prompt
   fi
}


# Only print banner if not in tmux session
if ! [[ -n "$TMUX" ]]; then
    print_cheatsheet_banner 0
fi
#
## Override C-l
#orig_ctrl_l=$(bindkey "^L")
#zle -N print_cheatsheet_banner
#bindkey "^L" print_cheatsheet_banner
