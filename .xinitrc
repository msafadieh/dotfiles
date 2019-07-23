#! /bin/sh

start-pulseaudio-x11
xrandr | grep -i "HDMI-A-0 connected" > /dev/null && xrandr --output eDP --off
exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
