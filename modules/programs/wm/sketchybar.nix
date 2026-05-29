{
  ...
}:
{
  flake.modules.homeManager.sketchybar =
    { pkgs, lib, ... }:
    lib.mkIf pkgs.stdenv.isDarwin {
      programs.sketchybar = {
        enable = true;
        configType = "bash";
        extraPackages = with pkgs; [
          aerospace
          jq
        ];

        config = ''
          #!/bin/bash

          PLUGIN_DIR="$CONFIG_DIR/plugins"

          # Kanagawa color palette
          export COLOR_BAR_BG="0xc01F1F28"
          export COLOR_WHITE="0xffDCD7BA"
          export COLOR_DIM="0xffC8C093"
          export COLOR_MUTED="0xff54546D"
          export COLOR_BLUE="0xff7E9CD8"
          export COLOR_GREEN="0xff98BB6C"
          export COLOR_RED="0xffC34043"
          export COLOR_YELLOW="0xffE6C384"
          export COLOR_ORANGE="0xffFFA066"
          export COLOR_VIOLET="0xff957FB8"
          export COLOR_AQUA="0xff7AA89F"
          export COLOR_SPRING_BLUE="0xff7FB4CA"
          export COLOR_SURFACE="0xff363646"
          export COLOR_TRANSPARENT="0x00000000"

          # Bar appearance (transparent overlay with blur)
          sketchybar --bar \
            position=top \
            height=40 \
            color=$COLOR_TRANSPARENT \
            blur_radius=30 \
            padding_left=10 \
            padding_right=10 \
            margin=0 \
            y_offset=0 \
            corner_radius=0 \
            shadow=off \
            font_smoothing=on \
            sticky=on \
            topmost=window

          # Default item properties
          sketchybar --default \
            icon.font="JetBrainsMono Nerd Font:Bold:16.0" \
            icon.color=$COLOR_WHITE \
            icon.padding_left=4 \
            icon.padding_right=4 \
            label.font="JetBrainsMono Nerd Font:Regular:14.0" \
            label.color=$COLOR_WHITE \
            label.padding_left=4 \
            label.padding_right=4 \
            background.height=28 \
            background.corner_radius=6 \
            padding_left=2 \
            padding_right=2

          # ─── AEROSPACE WORKSPACES ───
          sketchybar --add event aerospace_workspace_change

          for sid in $(aerospace list-workspaces --all); do
            sketchybar --add item space.$sid left \
              --subscribe space.$sid aerospace_workspace_change \
              --set space.$sid \
                background.color=$COLOR_SURFACE \
                background.corner_radius=6 \
                background.height=24 \
                background.drawing=off \
                icon.drawing=off \
                label="$sid" \
                label.color=$COLOR_DIM \
                label.font="JetBrainsMono Nerd Font:Bold:13.0" \
                label.padding_left=8 \
                label.padding_right=8 \
                click_script="aerospace workspace $sid" \
                script="$PLUGIN_DIR/aerospace.sh $sid"
          done

          # ─── FRONT APP ───
          sketchybar --add item front_app left \
            --set front_app \
              icon.drawing=off \
              label.color=$COLOR_SPRING_BLUE \
              label.font="JetBrainsMono Nerd Font:Bold:14.0" \
              script="$PLUGIN_DIR/front_app.sh" \
            --subscribe front_app front_app_switched

          # ─── MEDIA / NOW PLAYING ───
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

          # ─── CLOCK ───
          sketchybar --add item clock right \
            --set clock \
              icon= \
              icon.color=$COLOR_AQUA \
              label.color=$COLOR_WHITE \
              update_freq=30 \
              script="$PLUGIN_DIR/clock.sh"

          # ─── BATTERY ───
          sketchybar --add item battery right \
            --set battery \
              icon.color=$COLOR_GREEN \
              label.color=$COLOR_WHITE \
              update_freq=120 \
              script="$PLUGIN_DIR/battery.sh" \
            --subscribe battery system_woke power_source_change

          # ─── VOLUME ───
          sketchybar --add item volume right \
            --set volume \
              icon.color=$COLOR_YELLOW \
              label.color=$COLOR_WHITE \
              script="$PLUGIN_DIR/volume.sh" \
            --subscribe volume volume_change

          # ─── WIFI ───
          sketchybar --add item wifi right \
            --set wifi \
              icon=󰤨 \
              icon.color=$COLOR_SPRING_BLUE \
              label.color=$COLOR_DIM \
              script="$PLUGIN_DIR/wifi.sh" \
            --subscribe wifi wifi_change

          # Trigger initial update
          sketchybar --update
        '';
      };

      # Plugin scripts
      xdg.configFile = {
        "sketchybar/plugins/aerospace.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
              sketchybar --set "$NAME" background.drawing=on label.color=0xffDCD7BA
            else
              sketchybar --set "$NAME" background.drawing=off label.color=0xffC8C093
            fi
          '';
        };

        "sketchybar/plugins/front_app.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            sketchybar --set "$NAME" label="$INFO"
          '';
        };

        "sketchybar/plugins/clock.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            sketchybar --set "$NAME" label="$(date '+%a %d %b %H:%M')"
          '';
        };

        "sketchybar/plugins/battery.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
            CHARGING="$(pmset -g batt | grep 'AC Power')"
            if [ "$CHARGING" != "" ]; then
              ICON="󰂄"
              COLOR="0xff98BB6C"
            elif [ "$PERCENTAGE" -gt 80 ]; then
              ICON="󰁹"
              COLOR="0xff98BB6C"
            elif [ "$PERCENTAGE" -gt 60 ]; then
              ICON="󰂀"
              COLOR="0xffDCD7BA"
            elif [ "$PERCENTAGE" -gt 40 ]; then
              ICON="󰁾"
              COLOR="0xffE6C384"
            elif [ "$PERCENTAGE" -gt 20 ]; then
              ICON="󰁻"
              COLOR="0xffFFA066"
            else
              ICON="󰁺"
              COLOR="0xffC34043"
            fi
            sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="''${PERCENTAGE}%"
          '';
        };

        "sketchybar/plugins/volume.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            VOLUME="$INFO"
            if [ "$VOLUME" -eq 0 ]; then
              ICON="󰖁"
            elif [ "$VOLUME" -lt 30 ]; then
              ICON="󰕿"
            elif [ "$VOLUME" -lt 60 ]; then
              ICON="󰖀"
            else
              ICON="󰕾"
            fi
            sketchybar --set "$NAME" icon="$ICON" label="''${VOLUME}%"
          '';
        };

        "sketchybar/plugins/wifi.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            SSID="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')"
            if [ "$SSID" = "" ]; then
              sketchybar --set "$NAME" icon=󰤭 label="N/A"
            else
              sketchybar --set "$NAME" icon=󰤨 label="$SSID"
            fi
          '';
        };

        "sketchybar/plugins/media.sh" = {
          executable = true;
          text = ''
            #!/bin/bash
            STATE="$(echo "$INFO" | jq -r '.state')"
            if [ "$STATE" = "playing" ]; then
              MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
              sketchybar --set "$NAME" label="$MEDIA" drawing=on
            else
              sketchybar --set "$NAME" drawing=off
            fi
          '';
        };
      };
    };
}
