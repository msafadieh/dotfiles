#! /bin/bash
while sleep 5;
do
    if ! ping msafadieh.com -c 1; then
        systemctl restart "wg-quick@*"
    fi
done
