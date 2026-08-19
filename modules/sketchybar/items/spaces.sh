#!/usr/bin/env bash
# Aerospace workspace items for sketchybar

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --add event aerospace_workspace_change

WORKSPACES=("T" "W" "C" "D" "M" "1" "2" "3" "4" "5")

for sid in "${WORKSPACES[@]}"; do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.color=$COLOR_SURFACE \
    background.corner_radius=6 \
    background.height=26 \
    background.drawing=off \
    icon="${WORKSPACE_ICONS[$sid]}" \
    icon.color=$COLOR_MUTED \
    icon.font="$FONT_FACE:Bold:15.0" \
    icon.padding_left=8 \
    icon.padding_right=4 \
    label="" \
    label.color=$COLOR_DIM \
    label.font="$FONT_FACE:Regular:12.0" \
    label.padding_left=0 \
    label.padding_right=8 \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/aerospace.sh $sid"
done

# Set initial state for the focused workspace
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -n "$FOCUSED" ]; then
  sketchybar --set "space.$FOCUSED" \
    background.drawing=on \
    icon.color=$COLOR_BLUE
fi
