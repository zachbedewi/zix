#!/bin/bash
# Battery updater

source "$CONFIG_DIR/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ -n "$CHARGING" ]; then
  ICON="󰂄"
  COLOR="$COLOR_GREEN"
elif [ "$PERCENTAGE" -gt 80 ]; then
  ICON="󰁹"
  COLOR="$COLOR_GREEN"
elif [ "$PERCENTAGE" -gt 60 ]; then
  ICON="󰂀"
  COLOR="$COLOR_WHITE"
elif [ "$PERCENTAGE" -gt 40 ]; then
  ICON="󰁾"
  COLOR="$COLOR_YELLOW"
elif [ "$PERCENTAGE" -gt 20 ]; then
  ICON="󰁻"
  COLOR="$COLOR_ORANGE"
else
  ICON="󰁺"
  COLOR="$COLOR_RED"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
