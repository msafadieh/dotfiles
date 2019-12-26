#! /bin/sh
LOCATION=$1
# run every 15 minutes
while :
do
    WEATHER=$(curl http://wttr.in/$LOCATION\?m\&format\=%c%20%t)
    # run every second
    for run in {1..900}
    do
        RAM="$(free --mega | grep -o "[0-9]\+" | sed -n 2p)MB"
        # run every quarter second
        for run in {1..4}
        do

            DATE="$(date +"%a %d %b %Y λ %H:%M")"
            VOLUME="$(pactl list sinks | grep -o "[0-9]\+%" | head -n 1)"
            if [ $(< /sys/class/power_supply/BAT0/status) = "Full" ]; then
                BATTERY="full"
            else
                BATTERY="$(< /sys/class/power_supply/BAT0/capacity)%"
            fi
            xsetroot -name "[ $WEATHER ] [ $BATTERY ] [ $VOLUME ] [ $RAM ] [ $DATE ]"

            sleep 0.25
        done
        # break on blank weather
        [ -z "$WEATHER" ] && break
    done
done
