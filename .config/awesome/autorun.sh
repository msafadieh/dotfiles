xinput set-button-map "ELAN1300:00 04F3:3087 Touchpad" 1 1 3 4 5 6 7 8 9 10

compton -CGb

mpd

xautolock -time 10 -locker "systemctl suspend" -detectsleep -corners "0-00" -notify 30 -notifier "notify-send -u critical 'Going to sleep in 30 seconds'" &
