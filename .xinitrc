#! /bin/sh

mpd
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
if [ "$(xrandr | grep -i 'HDMI-A-0 connected')" ]; then
    dpset HDMI
fi
mkdir -p .cache/xmonad
exec xmonad >> ~/.cache/xmonad/stdout 2>> ~/.cache/xmonad/stderr
