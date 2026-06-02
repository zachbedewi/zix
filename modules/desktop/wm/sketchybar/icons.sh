#!/usr/bin/env bash
# Icon mappings for sketchybar items
# Using $'\Uxxxxxxxx' syntax so codepoints are explicit and editor-safe

# Workspace icons (keyed by aerospace workspace ID)
declare -A WORKSPACE_ICONS
WORKSPACE_ICONS[T]=$'\ue795'        # nf-dev-terminal
WORKSPACE_ICONS[W]=$'\U000f059f'    # nf-md-web
WORKSPACE_ICONS[C]=$'\U000f0172'    # nf-md-code_tags
WORKSPACE_ICONS[D]=$'\U000f0219'    # nf-md-file_document
WORKSPACE_ICONS[M]=$'\U000f0d9a'    # nf-md-music
WORKSPACE_ICONS[1]="1"
WORKSPACE_ICONS[2]="2"
WORKSPACE_ICONS[3]="3"
WORKSPACE_ICONS[4]="4"
WORKSPACE_ICONS[5]="5"

# App icons (used in workspace labels)
icon_for_app() {
  local icon
  case "$1" in
    kitty|Alacritty|Terminal|iTerm2|WezTerm|Ghostty) icon=$'\ue795' ;;        # nf-dev-terminal
    Firefox|Safari|Chrome|Arc|Zen*)                  icon=$'\U000f059f' ;;    # nf-md-web
    Code|Cursor|Zed|IntelliJ*|WebStorm*)             icon=$'\U000f0172' ;;    # nf-md-code_tags
    Finder)                                          icon=$'\U000f024b' ;;    # nf-md-folder
    Slack)                                           icon=$'\U000f0d6c' ;;    # nf-md-slack
    Discord)                                         icon=$'\U000f066f' ;;    # nf-md-discord (using chat)
    Spotify|Music)                                   icon=$'\U000f0d9a' ;;    # nf-md-music
    Messages)                                        icon=$'\U000f0361' ;;    # nf-md-message
    Mail)                                            icon=$'\U000f01ee' ;;    # nf-md-email
    Notes)                                           icon=$'\U000f039a' ;;    # nf-md-note
    Preview)                                         icon=$'\U000f0570' ;;    # nf-md-image
    "Claude Code")                                   icon=$'\U000f110b' ;;    # nf-md-robot
    *)                                               [ -n "$1" ] && icon=$'\U000000b7' ;;  # middle dot
  esac
  echo "$icon"
}
