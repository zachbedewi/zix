#!/usr/bin/env bash
# WiFi item

# shellcheck source=colors.sh
source "$CONFIG_DIR/colors.sh"

sketchybar --add item wifi right \
  --set wifi \
  icon=󰤨 \
  icon.color="$COLOR_SPRING_BLUE" \
  label.color="$COLOR_DIM" \
  script="$PLUGIN_DIR/wifi.sh" \
  --subscribe wifi wifi_change
