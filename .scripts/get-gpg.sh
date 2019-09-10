#!/bin/sh
bw sync
[[ $? -ne 0 ]] && export BW_SESSION=$(zenity --password | bw unlock --raw)
bw get password PGP | xclip -selection clipboard -rmlastnl && notify-send "Password copied!" || notify-send "Error!"
