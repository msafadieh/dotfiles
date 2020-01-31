#! /bin/sh
LOCATION=$1
# run every 60 minutes
while :
do
    #
    # WEATHER FROM wttr.in
    #
    WEATHER=$(curl http://wttr.in/$LOCATION\?m\&format\=%C%20@%20%t --connect-timeout 1)
    # handle rate limits
    [ $(wc -c <<< $WEATHER) -lt 50 ] && WEATHER=$(awk -F '@' '/@/ {print tolower($1) "@" $2}' <<< $WEATHER) || WEATHER=error
    # run every second
    for run in {1..3600}
    do
        #
        # FREE RAM
        #
        RAM="$(free --mega | grep -o "[0-9]\+" | sed -n 2p)MB"
        # run every quarter second
        for run in {1..4}
        do
            #
            # DATE AND TIME
            #
            DATE="$(date +"%a %d %b %Y λ %H:%M")"
            
            #
            # VOLUME
            #
            sinks="$(pactl list sinks)"
            VOLUME="$(awk '/[0-9]+%/ {pl = l; l = $5} END {print pl}' <<< $sinks)"
            MUTE="$(awk '/Mute/ {l=$2} END {print l}' <<< $sinks)"
            [ $MUTE = "yes" ] && VOLUME="$VOLUME [M]"

            #
            # BATTERY
            #
            if [ $(< /sys/class/power_supply/AC/online) = "0" ]; then
                ACSTATUS="bat"
            else
                ACSTATUS="ac"
            fi

            BATTERY=$(< /sys/class/power_supply/BAT0/capacity)
            if [ $ACSTATUS = "ac" ] || [ $BATTERY -gt 15 ] || [ -z $BAT_LOW ]; then
                BAT_CRITIC=0
                BAT_LOW=0
            elif [ $BATTERY -le 5 ]; then
                [ $BAT_CRITIC -eq 0 ] && notify-send -u critical "Critical low battery warning ($BATTERY%)"
                BAT_CRITIC=1
            elif [ $BATTERY -le 15 ]; then
                [ $BAT_LOW -eq 0 ] && notify-send "Low battery warning ($BATTERY %)"
                BAT_LOW=1
            fi

            # updates statusbar
            xsetroot -name "[ $WEATHER ] [ $BATTERY% ($ACSTATUS) ] [ $VOLUME ] [ $RAM ] [ $DATE ]"

            sleep 0.25
        done
        # break on blank weather
        [ -z "$WEATHER" ] && break
    done
done
