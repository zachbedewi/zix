#!/bin/bash
# Icon mappings for sketchybar items

# Workspace icons (keyed by aerospace workspace ID)
declare -A WORKSPACE_ICONS
WORKSPACE_ICONS=(
  [T]=""
  [W]="󰖟"
  [C]=""
  [D]="󰈙"
  [M]="󰝚"
  [1]="1"
  [2]="2"
  [3]="3"
  [4]="4"
  [5]="5"
)

# App icons (used in workspace labels)
icon_for_app() {
  case "$1" in
    kitty|Alacritty|Terminal|iTerm2|WezTerm|Ghostty) echo "" ;;
    Firefox|Safari|Chrome|Arc|Zen*) echo "󰖟" ;;
    Code|Cursor|Zed|IntelliJ*|WebStorm*) echo "" ;;
    Finder) echo "󰀶" ;;
    Slack) echo "󰒱" ;;
    Discord) echo "󰙯" ;;
    Spotify|Music) echo "󰝚" ;;
    Messages) echo "󰍡" ;;
    Mail) echo "󰇮" ;;
    Notes) echo "󰎞" ;;
    Preview) echo "󰋲" ;;
    "Claude Code") echo "󰚩" ;;
    *) [ -n "$1" ] && echo "󰘔" ;;
  esac
}
