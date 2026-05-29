{
  ...
}:
let
  fontPackages =
    pkgs: with pkgs; [
      # Nerd Font symbols (composable with any monospace font)
      nerd-fonts.symbols-only

      # Coding / Monospace
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.hack

      # Sans-serif (UI, documents, presentations)
      inter
      source-sans
      liberation_ttf

      # Serif (papers, reading, academic)
      source-serif
      libertine
      eb-garamond

      # CJK (Chinese, Japanese, Korean)
      noto-fonts-cjk-sans

      # Emoji
      noto-fonts-color-emoji

      # General Unicode coverage
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
