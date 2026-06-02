{
  ...
}:
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
  flake.modules.nixos.fonts =
    { pkgs, ... }:
    {
      fonts = {
        packages = fontPackages pkgs;
        fontDir.enable = true;
      };
    };

  flake.modules.darwin.fonts =
    { pkgs, ... }:
    {
      fonts.packages = fontPackages pkgs;
    };
}
