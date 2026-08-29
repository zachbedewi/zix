{
  flake.modules.homeManager.keepass =
    { pkgs, lib, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.keepassxc = {
        enable = true;
      };
    };
}
