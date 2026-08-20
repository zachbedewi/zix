#!/usr/bin/env bash
# Volume item

# shellcheck source=colors.sh
source "$CONFIG_DIR/colors.sh"

sketchybar --add item volume right \
  --set volume \
  icon.color="$COLOR_YELLOW" \
  label.color="$COLOR_WHITE" \
  script="$PLUGIN_DIR/volume.sh" \
  --subscribe volume volume_change
