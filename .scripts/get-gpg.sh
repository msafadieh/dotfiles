#!/bin/sh
lpass login me@msafadieh.com
lpass show 7973861828950534859 --password | tr -d \" | xclip -selection clipboard
