#! /bin/sh
LOCATION=$1
# run every 60 minutes

weather() {
    local weather
    
    weather=$(curl http://wttr.in/$LOCATION\?m\&format\=%C%20@%20%t --connect-timeout 1)

    if [ $(wc -c <<< $weather) -lt 50 ]; then 
        # first part all lowercase
        WEATHER="$(awk -F '@' '/@/ {print tolower($1) "@" $2}' <<< $weather)"
    else
        # rate limits
        WEATHER=error
    fi
}

ram() {
    RAM="MEM $(free --mega | awk '/Mem/ {print $3}')MB"
}

datetime() {
    DATETIME="$(date +"%a %d %b %Y λ %H:%M")"
}

volume() {
    local sinks vol mute

    sinks="$(pactl list sinks)"
    mute="$(awk '/Mute/ {l=$2} END {print l}' <<< $sinks)"
    vol="$(awk '/[0-9]+%/ {pl = l; l = $5} END {print pl}' <<< $sinks)"

    VOLUME="VOL $vol"
    if [ $mute = "yes" ]; then
        VOLUME="$VOLUME [M]"
    fi
}

battery() {
    local battery ac

    battery=$(< /sys/class/power_supply/BAT0/capacity)
    ac=$(< /sys/class/power_supply/AC/online)

    if [ $ac != "0" ] || [ $battery -gt 15 ] || [ -z $BAT_LOW ]; then
        BAT_CRITIC=0
        BAT_LOW=0
    elif [ $battery -le 5 ]; then
        [ $BAT_CRITIC -eq 0 ] && notify-send -u critical "Critical low battery warning ($battery%)"
        BAT_CRITIC=1
    elif [ $battery -le 15 ]; then
        [ $BAT_LOW -eq 0 ] && notify-send "Low battery warning ($battery %)"
        BAT_LOW=1
    fi
    
    BATTERY="BAT $battery%"
    [ $ac != "0" ] && BATTERY="$BATTERY (AC)"   
}



while :
do
    weather
    for run in {1..3600}
    do
        ram
        # run every quarter second
        for run in {1..4}
        do
            datetime 
            volume
            battery
            xsetroot -name "[ $WEATHER ] [ $BATTERY ] [ $VOLUME ] [ $RAM ] [ $DATETIME ]"
            sleep 0.25
        done
        # break on blank weather
        [ -z "$WEATHER" ] && break
    done
done

