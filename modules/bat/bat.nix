{
  flake.modules.homeManager.bat = { pkgs, lib, ... }: {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        prettybat
      ];
    };

    zix.shellAliases = {
      cat = "${lib.getExe pkgs.bat} --paging=never";
    };
  };
}
