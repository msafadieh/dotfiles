#! /bin/sh

I3CACHE=$HOME/.cache/i3

source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
#if [ "$(xrandr | grep -i 'HDMI-A-0 connected')" ]; then
#    dpset HDMI
#fi
#xrandr --output HDMI-A-0 --pos 0x0 --output eDP --pos 1920x0
xrandr --output HDMI-A-0 --primary --left-of eDP
mkdir -p "$I3CACHE"
exec i3 >> "$I3CACHE/stdout" 2>> "$I3CACHE/stderr"

