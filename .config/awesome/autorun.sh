[[ $(xrandr | grep -i "VGA-1 connected") ]] && [[ $(xrandr | grep -i "HDMI-1 connected") ]] && xrandr --output HDMI-1 --mode 1920x1080 --pos 1920x0 --output VGA-1 --mode 1920x1080 --pos 0x0 --output LVDS-1 --off 