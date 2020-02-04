#! /bin/sh
export LOCATION=12604
export XSECURELOCK_NO_COMPOSITE=1
export XSECURELOCK_PASSWORD_PROMPT=time_hex
xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

feh --bg-scale ./wallpaper &

trayer --transparent true --align right --edge bottom --widthtype request &
nextcloud &
nm-applet &
xflux -z $LOCATION &
picom --no-fading-openclose &
caffeine &

./statusbar.sh $LOCATION &

