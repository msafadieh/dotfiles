#! /bin/sh

I3CACHE=$HOME/.cache/i3

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
xrandr --output HDMI-A-0 --primary --left-of eDP
mkdir -p "$I3CACHE"
exec i3 >> "$I3CACHE/stdout" 2>> "$I3CACHE/stderr"

