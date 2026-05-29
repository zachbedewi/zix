{
  ...
}:
{
  flake.modules.homeManager.aerospace =
    { pkgs, lib, ... }:
    lib.mkIf pkgs.stdenv.isDarwin {
      programs.aerospace = {
        enable = true;

        launchd = {
          enable = true;
          keepAlive = true;
        };

        settings = {
          config-version = 2;
          auto-reload-config = true;

          after-startup-command = [
            "exec-and-forget borders active_color=0xff7E9CD8 inactive_color=0x00000000 width=6.0 style=round"
            "exec-and-forget sketchybar"
          ];

          exec-on-workspace-change = [
            "/bin/bash"
            "-c"
            "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];

          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";
          accordion-padding = 30;

          gaps = {
            inner.horizontal = 10;
            inner.vertical = 10;
            outer.left = 10;
            outer.right = 10;
            outer.bottom = 10;
            outer.top = 50;
          };

          key-mapping.preset = "qwerty";

          mode.main.binding = {
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            alt-minus = "resize smart -50";
            alt-equal = "resize smart +50";

            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";
            alt-f = "fullscreen";
            alt-shift-f = "macos-native-fullscreen";
            alt-shift-space = "layout floating tiling";

            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";

            alt-t = "workspace T";
            alt-w = "workspace W";
            alt-c = "workspace C";
            alt-d = "workspace D";
            alt-m = "workspace M";

            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";

            alt-shift-t = "move-node-to-workspace T";
            alt-shift-w = "move-node-to-workspace W";
            alt-shift-c = "move-node-to-workspace C";
            alt-shift-d = "move-node-to-workspace D";
            alt-shift-m = "move-node-to-workspace M";

            alt-tab = "workspace-back-and-forth";
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            alt-shift-q = "close";
            alt-shift-b = "balance-sizes";

            alt-leftSquareBracket = "focus-monitor prev";
            alt-rightSquareBracket = "focus-monitor next";

            alt-shift-semicolon = "mode service";
            alt-r = "mode resize";
          };

          mode.resize.binding = {
            h = "resize width -50";
            j = "resize height +50";
            k = "resize height -50";
            l = "resize width +50";
            minus = "resize smart -50";
            equal = "resize smart +50";
            enter = "mode main";
            esc = "mode main";
          };

          mode.service.binding = {
            esc = [
              "reload-config"
              "mode main"
            ];
            r = [
              "flatten-workspace-tree"
              "mode main"
            ];
            f = [
              "layout floating tiling"
              "mode main"
            ];
            backspace = [
              "close-all-windows-but-current"
              "mode main"
            ];
            alt-shift-h = [
              "join-with left"
              "mode main"
            ];
            alt-shift-j = [
              "join-with down"
              "mode main"
            ];
            alt-shift-k = [
              "join-with up"
              "mode main"
            ];
            alt-shift-l = [
              "join-with right"
              "mode main"
            ];
          };

          on-window-detected = [
            {
              "if".app-id = "com.apple.systempreferences";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.SystemPreferences";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.finder";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.calculator";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.ActivityMonitor";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.FontBook";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.ScreenSharing";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.Preview";
              run = "layout floating";
            }
            {
              "if".app-id = "com.agilebits.onepassword7";
              run = "layout floating";
            }
            {
              "if".app-id = "com.1password.1password";
              run = "layout floating";
            }
            {
              "if".app-id = "com.raycast.macos";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.Stickies";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.iCal";
              run = "layout floating";
            }
          ];
        };
      };
    };
}
