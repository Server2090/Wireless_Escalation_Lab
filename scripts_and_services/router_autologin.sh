#!/usr/bin/env bash

#setting up the basic variables
SSID="ECC-GUEST"
ROUTER_URL="http://192.168.1.1"
BROWSER="firefox-esr"
ADMIN_USER=""
ADMIN_PASS="AdminSecure123!"
BROWSER_START_DELAY=20	#how long to wait for the browser to load
SLEEP_TIME=60	#how long to sleep before next attempt
LOGIN_SLEEP_TIME=10
LOOP_SLEEP=100
BROWSER_CREATION_SLEEP=20

while true; do
  # checks to make sure the right SSID is in use
  CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}')

  echo "$CURRENT_SSID"
  if [ "$CURRENT_SSID" != "$SSID" ]; then
    echo "sleeping because not right SSID"
    sleep "$LOOP_SLEEP"
    continue
  fi 

  # checks to make sure the router is reachable
  $BROWSER "$ROUTER_URL" >/dev/null 2>&1 &
  BROWSER_PID=$!	# assigns the process id to the one that was just created 
  echo "BROWSER process id created"

  # sleeps so that the router can respond in time
  sleep "$BROWSER_CREATION_SLEEP"

  # attempts to login with credentials with grace failover
  if command -v xdotool >/dev/null 2>&1; then
    xdotool type "$ADMIN_USER" 2>/dev/null || true
    xdotool key Tab 2>/dev/null || true
    xdotool type "$ADMIN_PASS" 2>/dev/null || true
    xdotool key Return 2>/dev/null || true
    echo "Entering credentials"
  fi 

  # gives the server time to respond
  sleep "$LOGIN_SLEEP_TIME"
  echo "LOGGING IN"

  # closes the last opened window
  xdotool key ALT+F4 2>/dev/null || kill "$BROWSER_PID" 2>/dev/null || true
  echo "closing that window"

  # waits before it tries all of this again
  echo "sleep time"
  sleep "$SLEEP_TIME"
done
