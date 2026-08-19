#!/usr/bin/env bash
# Battery item

source "$CONFIG_DIR/colors.sh"

sketchybar --add item battery right \
  --set battery \
  icon.color=$COLOR_GREEN \
  label.color=$COLOR_WHITE \
  update_freq=120 \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change
