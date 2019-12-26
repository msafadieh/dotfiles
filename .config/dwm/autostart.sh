#! /bin/sh
export LOCATION=04038
export XSECURELOCK_PASSWORD_PROMPT=time_hex
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

feh --bg-scale ./wallpaper &

nextcloud &
blueman-applet &
nm-applet &
xflux -z $LOCATION &

./statusbar.sh $LOCATION &

