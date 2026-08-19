#!/usr/bin/env bash
# Clock item

source "$CONFIG_DIR/colors.sh"

sketchybar --add item clock right \
  --set clock \
  icon= \
  icon.color=$COLOR_AQUA \
  label.color=$COLOR_WHITE \
  update_freq=30 \
  script="$PLUGIN_DIR/clock.sh"
