#!/usr/bin/env bash

# shellcheck source=colors.sh
source "$CONFIG_DIR/colors.sh"
# shellcheck source=icons.sh
source "$CONFIG_DIR/icons.sh"

SID="$1"

# If no focused workspace info from the event, query aerospace directly
if [ -z "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
  AEROSPACE_FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

APPS="$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null)"
APP_ICONS=""

while IFS= read -r app; do
  [ -z "$app" ] && continue
  icon="$(icon_for_app "$app")"
  APP_ICONS+="${icon} "
done <<<"$APPS"

APP_ICONS="${APP_ICONS% }"

if [ "$SID" = "$AEROSPACE_FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    icon.color="$COLOR_BLUE" \
    label="$APP_ICONS" \
    label.color="$COLOR_WHITE"
elif [ -n "$APP_ICONS" ]; then
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$COLOR_WHITE" \
    label="$APP_ICONS" \
    label.color="$COLOR_MUTED"
else
  sketchybar --set "$NAME" \
    background.drawing=off \
    icon.color="$COLOR_MUTED" \
    label="" \
    label.color="$COLOR_MUTED"
fi
