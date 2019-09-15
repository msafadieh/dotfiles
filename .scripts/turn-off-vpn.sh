turnoffvpn() {
  sudo systemctl stop mullvad-vpn@"*"
  sudo systemctl stop wg-quick@"*"
  if [ $1 ] 
    then
      sudo systemctl start mullvad-vpn@"$1"
  fi
}

turnoffvpn $1