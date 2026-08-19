{
  flake.modules.homeManager.sketchybar =
    { pkgs, lib, ... }:
    let
      fontFace = "JetBrainsMono Nerd Font Mono";
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      programs.sketchybar = {
        enable = true;
        configType = "bash";
        extraPackages = with pkgs; [
          bash
          aerospace
          jq
        ];

        config = ''
          #!/bin/bash

          # CONFIG_DIR is provided by sketchybar itself
          export PLUGIN_DIR="$CONFIG_DIR/plugins"
          export FONT_FACE="${fontFace}"

          source "$CONFIG_DIR/colors.sh"

          # ─── BAR ───
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

          # ─── DEFAULTS ───
          sketchybar --default \
            icon.font="$FONT_FACE:Bold:16.0" \
            icon.color=$COLOR_WHITE \
            icon.padding_left=4 \
            icon.padding_right=4 \
            label.font="$FONT_FACE:Regular:14.0" \
            label.color=$COLOR_WHITE \
            label.padding_left=4 \
            label.padding_right=4 \
            background.height=28 \
            background.corner_radius=6 \
            padding_left=2 \
            padding_right=2

          # ─── LEFT ITEMS ───
          source "$CONFIG_DIR/items/spaces.sh"
          source "$CONFIG_DIR/items/front_app.sh"

          # ─── CENTER ITEMS ───
          source "$CONFIG_DIR/items/media.sh"

          # ─── RIGHT ITEMS ───
          source "$CONFIG_DIR/items/clock.sh"
          source "$CONFIG_DIR/items/battery.sh"
          source "$CONFIG_DIR/items/volume.sh"
          source "$CONFIG_DIR/items/wifi.sh"

          # ─── FORCE INITIAL UPDATE ───
          sketchybar --update
        '';
      };

      xdg.configFile = {
        "sketchybar/colors.sh" = {
          source = ./colors.sh;
          executable = true;
        };
        "sketchybar/icons.sh" = {
          source = ./icons.sh;
          executable = true;
        };

        # Items
        "sketchybar/items/spaces.sh" = {
          source = ./items/spaces.sh;
          executable = true;
        };
        "sketchybar/items/front_app.sh" = {
          source = ./items/front_app.sh;
          executable = true;
        };
        "sketchybar/items/media.sh" = {
          source = ./items/media.sh;
          executable = true;
        };
        "sketchybar/items/clock.sh" = {
          source = ./items/clock.sh;
          executable = true;
        };
        "sketchybar/items/battery.sh" = {
          source = ./items/battery.sh;
          executable = true;
        };
        "sketchybar/items/volume.sh" = {
          source = ./items/volume.sh;
          executable = true;
        };
        "sketchybar/items/wifi.sh" = {
          source = ./items/wifi.sh;
          executable = true;
        };

        # Plugins
        "sketchybar/plugins/aerospace.sh" = {
          source = ./plugins/aerospace.sh;
          executable = true;
        };
        "sketchybar/plugins/front_app.sh" = {
          source = ./plugins/front_app.sh;
          executable = true;
        };
        "sketchybar/plugins/media.sh" = {
          source = ./plugins/media.sh;
          executable = true;
        };
        "sketchybar/plugins/clock.sh" = {
          source = ./plugins/clock.sh;
          executable = true;
        };
        "sketchybar/plugins/battery.sh" = {
          source = ./plugins/battery.sh;
          executable = true;
        };
        "sketchybar/plugins/volume.sh" = {
          source = ./plugins/volume.sh;
          executable = true;
        };
        "sketchybar/plugins/wifi.sh" = {
          source = ./plugins/wifi.sh;
          executable = true;
        };
      };
    };
}
