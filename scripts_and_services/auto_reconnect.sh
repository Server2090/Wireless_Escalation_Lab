#!/usr/bin/env bash

#all log files are saved to /var/log/wifi_reconnect.log

IFACE="wlan0"
SSID="ECC-GUEST"
CON_NAME="lock_$SSID"

while true; do
  echo "$(date): Checking connection..." >> "/var/log/wifi_reconnect.log"
  #checks to see if the current interface is connected to the right SSID
  CUR_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1 == "yes" {print $2;exit}')

  if [ "$CUR_SSID" != "$SSID" ]; then
    nmcli device disconnect "$IFACE" >> /var/log/wifi_reconnect.log 2>&1 #disconnects the current interface
    nmcli connection up "$CON_NAME" >> /var/log/wifi_reconnect.log 2>&1	#reconnects to the correct network
  fi 

  sleep 10
done
