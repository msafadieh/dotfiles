[[ $(xrandr | grep -i "VGA-1 connected") ]] && [[ $(xrandr | grep -i "HDMI-1 connected") ]] && xrandr --output HDMI-1 --mode 1920x1080 --pos 1920x0 --output VGA-1 --mode 1920x1080 --pos 0x0 --output LVDS-1 --off

xinput set-button-map "ELAN1300:00 04F3:3087 Touchpad" 1 1 3 4 5 6 7 8 9 10

