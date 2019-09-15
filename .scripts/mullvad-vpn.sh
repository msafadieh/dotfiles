#! /bin/bash

choose_vpn() {
  server=$(ls /etc/wireguard | grep -Po "mullvad-us[0-9]+" | shuf -n 1)
  systemctl start wg-quick@$server
  echo $server > /etc/mullvad-server
}

sleep $1
choose_vpn
