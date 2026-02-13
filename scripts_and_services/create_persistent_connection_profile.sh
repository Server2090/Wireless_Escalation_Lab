#!/bin/bash 

#creates the generic variables needed for future 
IFACE="wlan0"	#sets the wifi interface
SSID="ECC-GUEST"	#sets the SSID to connect to
PASS="corpwirelessnetwork"	#sets the password needed to connect
CON_NAME="lock_$SSID"	#sets the name of the connection to be used in the future

nmcli connection add type wifi ifname "$IFACE" con-name "$CON_NAME" ssid "$SSID"
nmcli connection modify "$CON_NAME" wifi-sec.key-mgmt wpa-psk
nmcli connection modify "$CON_NAME" wifi-sec.psk "$PASS"
nmcli connection modify "$CON_NAME" connection.autoconnect yes
