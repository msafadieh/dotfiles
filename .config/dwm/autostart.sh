#! /bin/sh
[ -f "$HOME/.cache/dwm-lock" ] && exit
touch "$HOME/.cache/dwm-lock"
export LOCATION=12604
export XSECURELOCK_NO_COMPOSITE=1
export XSECURELOCK_PASSWORD_PROMPT=time_hex
xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

feh --bg-scale ./wallpaper &

trayer --transparent true --align right --edge bottom --distance 8 --margin 8 --widthtype request --tint "#222222" --alpha 184 &
syncnc -w &
xflux -z $LOCATION &
picom --no-fading-openclose &
caffeine &

statusbar $LOCATION &

