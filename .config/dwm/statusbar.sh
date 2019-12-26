#! /bin/sh
LOCATION=$1
# run every 60 minutes
while :
do
    WEATHER=$(curl http://wttr.in/$LOCATION\?m\&format\=%C%20@%20%t --connect-timeout 1 | tr '[:upper:]' '[:lower:]')
    # run every second
    for run in {1..3600}
    do
        RAM="$(free --mega | grep -o "[0-9]\+" | sed -n 2p)MB"
        # run every quarter second
        for run in {1..4}
        do

            DATE="$(date +"%a %d %b %Y λ %H:%M")"
            VOLUME="$(pactl list sinks | grep -o "[0-9]\+%" | head -n 1)"
            if [ $(< /sys/class/power_supply/AC/online) = "0" ]; then
                ACSTATUS="bat"
            else
                ACSTATUS="ac"
            fi
            BATTERY="$(< /sys/class/power_supply/BAT0/capacity)%"
            xsetroot -name "[ $WEATHER ] [ $BATTERY ($ACSTATUS) ] [ $VOLUME ] [ $RAM ] [ $DATE ]"

            sleep 0.25
        done
        # break on blank weather
        [ -z "$WEATHER" ] && break
    done
done
