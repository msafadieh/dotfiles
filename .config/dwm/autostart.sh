#! /bin/sh
export LOCATION=12604
export XSECURELOCK_PASSWORD_PROMPT=time_hex
xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

feh --bg-scale ./wallpaper &

nextcloud &
nm-applet &
xflux -z $LOCATION &
picom &
caffeine &

./statusbar.sh $LOCATION &

