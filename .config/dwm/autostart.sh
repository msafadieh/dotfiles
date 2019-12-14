#! /bin/sh

feh --bg-scale ~/.wallpaper &

pidof nextcloud || nextcloud &
blueman-applet &
pidof nm-applet || nm-applet &
pidof xflux || xflux -z 12604 &
pidof xautolock || xautolock -time 15 -locker 'systemctl suspend' -detectsleep -corners '0-00' &

./statusbar.sh &

