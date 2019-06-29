#!/bin/sh
[[ $(lpass status) == "Not logged in." ]] && lpass login me@msafadieh.com
lpass show 7973861828950534859 --password --clip
