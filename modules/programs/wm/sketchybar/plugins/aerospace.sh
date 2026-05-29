#!/usr/bin/env bash
# Aerospace workspace change handler
# Called with workspace ID as $1
# Env vars from trigger: FOCUSED_WORKSPACE, PREV_WORKSPACE

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

SID="$1"

# Build app icon string for this workspace
APPS="$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null)"
APP_ICONS=""

while IFS= read -r app; do
  icon="$(icon_for_app "$app")"
  [ -n "$icon" ] && APP_ICONS+="$icon "
done <<< "$APPS"

# Trim trailing space
APP_ICONS="${APP_ICONS% }"

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    icon.color=$COLOR_BLUE \
    label="$APP_ICONS" \
    label.color=$COLOR_WHITE
elif [ -n "$APP_ICONS" ]; then
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color=$COLOR_WHITE \
    label="$APP_ICONS" \
    label.color=$COLOR_MUTED
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color=$COLOR_MUTED \
    label="" \
    label.color=$COLOR_MUTED
fi
