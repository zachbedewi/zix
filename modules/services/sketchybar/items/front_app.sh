#!/usr/bin/env bash
# Front app item - shows the currently focused application

source "$CONFIG_DIR/colors.sh"

sketchybar --add item separator left \
  --set separator \
  icon="│" \
  icon.color=$COLOR_MUTED \
  icon.padding_left=6 \
  icon.padding_right=6 \
  label.drawing=off \
  background.drawing=off

sketchybar --add item front_app left \
  --set front_app \
  icon.drawing=off \
  label.color=$COLOR_SPRING_BLUE \
  label.font="$FONT_FACE:Bold:14.0" \
  script="$PLUGIN_DIR/front_app.sh" \
  --subscribe front_app front_app_switched
