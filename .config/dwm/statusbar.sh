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
    RAM="$(free --mega | awk '/Mem/ {print $3}')MB"
}

datetime() {
    DATETIME="$(date +"%a %d %b λ %H:%M")"
}

volume() {
    local sinks mute

    sinks="$(pactl list sinks)"
    mute="$(awk '/Mute/ {l=$2} END {print l}' <<< $sinks)"
    VOLUME="$(awk '/[0-9]+%/ {pl = l; l = $5} END {print pl}' <<< $sinks)"

    VOLUME_ICON="墳"
    if [ $mute = "yes" ]; then
        VOLUME_ICON="婢"
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

    
    BATTERY="$battery%"
    if [ $ac != "0" ]; then
        BATTERY_ICON=""
    elif [ $battery -ge 95 ]; then
        BATTERY_ICON=" "
    elif [ $battery -ge 75 ]; then
        BATTERY_ICON=" "
    elif [ $battery -ge 50 ]; then
        BATTERY_ICON=" "
    elif [ $battery -ge 5 ]; then
        BATTERY_ICON=" "
    else
        BATTERY_ICON=" "
    fi
    
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
            xsetroot -name " $WEATHER   $RAM  $BATTERY_ICON $BATTERY  $VOLUME_ICON $VOLUME   $DATETIME "
            sleep 0.25
        done
        # break on blank weather
        [ -z "$WEATHER" ] && break
    done
done

