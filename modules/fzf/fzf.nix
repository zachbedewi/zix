{
  flake.modules.homeManager.fzf = { pkgs, lib, ... }: {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;

      defaultCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
      fileWidgetCommand = "${lib.getExe pkgs.fd} --type=f --hidden --exclude=.git";
      changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type=d --hidden --exclude=.git";

      defaultOptions = [
        "--layout=reverse"
        "--exact"
        "--multi"
        "--no-mouse"
        "--info=inline"

        # Style
        "--ansi"
        "--with-nth=1"
        "--header-first"
        "--border=rounded"
      ];
    };
  };
}
