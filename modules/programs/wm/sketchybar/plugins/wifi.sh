#!/bin/bash
# WiFi change handler

INFO_OUT="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null)"
SSID="$(echo "$INFO_OUT" | awk '/ SSID/ {print substr($0, index($0, $2))}')"

if [ -z "$SSID" ]; then
  sketchybar --set "$NAME" icon=󰤭 label="N/A"
else
  sketchybar --set "$NAME" icon=󰤨 label="$SSID"
fi
