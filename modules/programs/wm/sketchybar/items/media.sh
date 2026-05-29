#!/usr/bin/env bash
# Media / now playing item

source "$CONFIG_DIR/colors.sh"

sketchybar --add item media center \
  --set media \
    icon=󰝚 \
    icon.color=$COLOR_VIOLET \
    label.max_chars=40 \
    label.color=$COLOR_DIM \
    scroll_texts=on \
    updates=on \
    script="$PLUGIN_DIR/media.sh" \
  --subscribe media media_change
