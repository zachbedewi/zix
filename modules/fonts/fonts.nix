let
  fontPackages =
    pkgs: with pkgs; [
      # Coding / Monospace
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.hack

      # Sans-serif
      inter
      source-sans
      liberation_ttf

      # Serif
      source-serif
      libertine
      eb-garamond

      # CJK (Chinese, Japanese, Korean)
      noto-fonts-cjk-sans

      # Symbols/Emoji
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
      noto-fonts
    ];
in
{
  flake.modules = {
    nixos.fonts = { pkgs, ... }: {
      fonts = {
        enableDefaultPackages = true;
        packages = fontPackages pkgs;
        fontDir.enable = true;

        fontconfig = {
          enable = true;
          antialias = true;
          hinting = {
            enable = true;
            style = "slight";
          };

          subpixel.rgba = "rgb";
          defaultFonts = {
            serif = [
              "Source Serif"
              "Noto Serif"
            ];
            sansSerif = [
              "Inter"
              "Noto Sans"
            ];
            monospace = [ "JetBrainsMono Nerd Font" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
    };

    darwin.fonts = { pkgs, ... }: { fonts.packages = fontPackages pkgs; };

    homeManager.fonts = { pkgs, ... }: {
      fonts.fontconfig.enable = true;

      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;

        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };

}
