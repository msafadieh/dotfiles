#! /bin/sh

mpd
gnome-keyring
xrandr | grep -i "HDMI-A-0 connected" > /dev/null && xrandr --output eDP --off
mkdir -p .cache/xmonad
exec xmonad >> ~/.cache/xmonad/stdout 2>> ~/.cache/xmonad/stderr
