#! /bin/sh

xrandr | grep -i "HDMI-1 connected" > /dev/null && xrandr --output eDP-1 --off
mkdir -p .cache/xmonad
exec xmonad >> ~/.cache/xmonad/stdout 2>> ~/.cache/xmonad/stderr
