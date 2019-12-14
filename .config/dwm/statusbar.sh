#! /bin/sh

while :
do
    RAM="$(free --mega | grep -o "[0-9]\+" | sed -n 2p)MB"
    for run in {1..4}
    do
        DATE="$(date +"%a %d %b %Y λ %H:%M")"
        VOLUME="$(pactl list sinks | grep -o "[0-9]\+%" | head -n 1)"
        if [ $(< /sys/class/power_supply/BAT0/status) = "Full" ]; then
            BATTERY="full"
        else
            BATTERY="$(< /sys/class/power_supply/BAT0/capacity)%"
        fi
        xsetroot -name "[ $BATTERY ] [ $VOLUME ] [ $RAM ] [ $DATE ]"
        sleep 0.25
    done
done
