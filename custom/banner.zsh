banner="                                                                                                                                         +------------------+-----------------------------------------+
                                                                                                                                         | Ctrl + B         | Move the cursor back one character      |
                                                                                                                                         | Alt  + B         | Move the cursor back one word           |
                                                                     +------------------+-----------------------------------------+      | Ctrl + F         | Move the cursor forward one character   |
 +------------------+-----------------------------------------+      | Ctrl + P         | Recall the previous command             |      | Alt  + F         | Move the cursor forward one word        |
 | Alt  + K         | Kafka Topic FZF                         |      | Ctrl + N         | Recall the next command                 |      +------------------+-----------------------------------------+
 | Ctrl + Z         | CD History                              |      +------------------+-----------------------------------------+      | Ctrl + W         | Delete the word before the cursor       |
 | Ctrl + X         | Easy-Motion                             |      | Ctrl + U         | Clear the text before the cursor        |      | Ctrl + H         | Delete the character before the cursor  |
 | Ctrl + J         | jq REPL                                 |      | Ctrl + K         | Clear the text after the cursor         |      | Ctrl + D         | Delete the character after the cursor   |
 | Alt  + A         | ASN IP Lookup                           |      | Ctrl + Y         | Yank (paste) the last cut/deleted       |      | Alt  + D         | Delete the word after the cursor        |
 +------------------+-----------------------------------------+      +------------------+-----------------------------------------+      +------------------+-----------------------------------------+"


print_cheatsheet_banner()
{
   echo "$banner"
}
print_cheatsheet_banner

# Override C-l
orig_ctrl_l=$(bindkey "^L")
function custom_clear_screen()
{
    zle clear-screen # original
    echo ""
    print_cheatsheet_banner
    zle reset-prompt
}
zle -N custom_clear_screen
bindkey "^L" custom_clear_screen
