{
  ...
}:
{
  flake.modules.homeManager.starship =
    { ... }:
    {
      programs.starship = {
        enable = true;

        enableZshIntegration = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;

        settings = {
          add_newline = true;
          scan_timeout = 10;
          command_timeout = 500;

          format = builtins.concatStringsSep "" [
            "$username"
            "$hostname"
            "$directory"
            "$git_branch"
            "$git_status"
            "$nix_shell"
            "$python"
            "$rust"
            "$golang"
            "$nodejs"
            "$java"
            "$fill"
            "$cmd_duration"
            "$status"
            "$time"
            "$line_break"
            "$character"
          ];

          character = {
            success_symbol = "[❯](bold #98BB6C)";
            error_symbol = "[❯](bold #C34043)";
            vimcmd_symbol = "[❮](bold #7E9CD8)";
            vimcmd_replace_one_symbol = "[❮](bold #957FB8)";
            vimcmd_replace_symbol = "[❮](bold #957FB8)";
            vimcmd_visual_symbol = "[❮](bold #E6C384)";
          };

          fill = {
            symbol = " ";
          };

          directory = {
            style = "bold #7E9CD8";
            truncation_length = 4;
            truncation_symbol = "…/";
            truncate_to_repo = true;
            read_only = " 󰌾";
            read_only_style = "#C34043";
          };

          git_branch = {
            symbol = " ";
            style = "#957FB8";
            format = "[$symbol$branch(:$remote_branch)]($style) ";
          };

          git_status = {
            format = "([$all_status$ahead_behind]($style) )";
            style = "#E6C384";
            staged = "[+$count](#98BB6C) ";
            modified = "[~$count](#E6C384) ";
            untracked = "[?$count](#7AA89F) ";
            deleted = "[-$count](#C34043) ";
            conflicted = "[!$count](#FF5D62) ";
            ahead = "[⇡$count](#98BB6C)";
            behind = "[⇣$count](#C34043)";
            diverged = "[⇡$ahead_count⇣$behind_count](#FFA066)";
            stashed = "[*$count](#957FB8) ";
          };

          nix_shell = {
            symbol = " ";
            style = "#7FB4CA";
            format = "[$symbol$state( \\($name\\))]($style) ";
            heuristic = true;
          };

          cmd_duration = {
            min_time = 3000;
            style = "#54546D";
            format = "[$duration]($style) ";
            show_milliseconds = false;
          };

          status = {
            disabled = false;
            style = "#C34043";
            symbol = "✘ ";
            format = "[$symbol$status]($style) ";
          };

          time = {
            disabled = false;
            style = "#54546D";
            format = "[$time]($style)";
            time_format = "%H:%M";
          };

          username = {
            show_always = false;
            style_user = "#7AA89F";
            style_root = "#C34043";
            format = "[$user]($style)@";
          };

          hostname = {
            ssh_only = true;
            style = "#7FB4CA";
            format = "[$hostname]($style) ";
          };

          python = {
            symbol = " ";
            style = "#E6C384";
            format = "[$symbol$version( \\($virtualenv\\))]($style) ";
          };

          rust = {
            symbol = " ";
            style = "#FFA066";
            format = "[$symbol$version]($style) ";
          };

          golang = {
            symbol = " ";
            style = "#7FB4CA";
            format = "[$symbol$version]($style) ";
          };

          nodejs = {
            symbol = " ";
            style = "#98BB6C";
            format = "[$symbol$version]($style) ";
          };

          java = {
            symbol = " ";
            style = "#C34043";
            format = "[$symbol$version]($style) ";
          };
        };
      };
    };
}
