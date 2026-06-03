{
  inputs,
  ...
}:
{
  flake.modules.homeManager.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;

        # Pull theme directly from the flake input — always in sync with lock
        extraConfig = builtins.readFile "${inputs.kanagawa}/extras/kitty/kanagawa.conf";

        font = {
          name = "JetBrainsMono Nerd Font";
          size = 13;
        };

        settings = {
          # Window
          window_padding_width = 8;
          placement_strategy = "center";
          hide_window_decorations = "titlebar-only";
          confirm_os_window_close = -1;
          remember_window_size = true;
          initial_window_width = "120c";
          initial_window_height = "36c";
          window_margin_width = 0;

          # Tab bar
          tab_bar_edge = "top";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_title_template = "{index}: {title}";
          active_tab_font_style = "bold";
          inactive_tab_font_style = "normal";

          # Cursor
          cursor_shape = "beam";
          cursor_beam_thickness = "1.5";
          cursor_blink_interval = 0;

          # Scrollback
          scrollback_lines = 10000;
          scrollback_pager_history_size = 100;

          # Mouse
          mouse_hide_wait = "3.0";
          url_style = "curly";
          open_url_with = "default";
          copy_on_select = "clipboard";
          strip_trailing_spaces = "smart";

          # Bell
          enable_audio_bell = false;
          visual_bell_duration = "0.0";
          window_alert_on_bell = true;
          bell_on_tab = "🔔 ";

          # Performance
          repaint_delay = 10;
          input_delay = 3;
          sync_to_monitor = true;

          # Advanced
          allow_remote_control = "socket-only";
          listen_on = "unix:/tmp/kitty";
          shell_integration = "enabled";
          term = "xterm-kitty";

          # macOS specific
          macos_option_as_alt = true;
          macos_quit_when_last_window_closed = false;
          macos_traditional_fullscreen = false;
          macos_show_window_title_in = "menubar";
        };

        keybindings = {
          # Window management
          "ctrl+shift+enter" = "new_window_with_cwd";
          "ctrl+shift+n" = "new_os_window_with_cwd";
          "ctrl+shift+w" = "close_window";
          "ctrl+shift+]" = "next_window";
          "ctrl+shift+[" = "previous_window";

          # Tab management
          "ctrl+shift+t" = "new_tab_with_cwd";
          "ctrl+shift+q" = "close_tab";
          "ctrl+shift+right" = "next_tab";
          "ctrl+shift+left" = "previous_tab";
          "ctrl+shift+." = "move_tab_forward";
          "ctrl+shift+," = "move_tab_backward";
          "ctrl+shift+alt+t" = "set_tab_title";

          # Direct tab switching
          "ctrl+alt+1" = "goto_tab 1";
          "ctrl+alt+2" = "goto_tab 2";
          "ctrl+alt+3" = "goto_tab 3";
          "ctrl+alt+4" = "goto_tab 4";
          "ctrl+alt+5" = "goto_tab 5";

          # Layout
          "ctrl+shift+l" = "next_layout";

          # Font size
          "ctrl+shift+equal" = "change_font_size all +1.0";
          "ctrl+shift+minus" = "change_font_size all -1.0";
          "ctrl+shift+0" = "change_font_size all 0";

          # Scrollback
          "ctrl+shift+k" = "scroll_line_up";
          "ctrl+shift+j" = "scroll_line_down";
          "ctrl+shift+page_up" = "scroll_page_up";
          "ctrl+shift+page_down" = "scroll_page_down";
          "ctrl+shift+home" = "scroll_home";
          "ctrl+shift+end" = "scroll_end";
          "ctrl+shift+h" = "show_scrollback";
        };
      };
    };
}
