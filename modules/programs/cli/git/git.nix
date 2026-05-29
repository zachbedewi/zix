{
  ...
}:
{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      userName = "Zach Bedewi";

      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          side-by-side = true;
          line-numbers = true;
        };
      };

      extraConfig = {
        init.defaultBranch = "mainline";
        push.autoSetupRemote = true;
        pull.rebase = true;

        branch.sort = "-committerdate";
        column.ui = "auto";

        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };

        fetch.prune = true;
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };

        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };

      aliases = {
        co = "checkout";
        cm = "commit -m";
        st = "status";
        br = "branch";
        df = "diff";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        undo = "reset --soft HEAD~1";
        prune-dry = "fetch --prune --dry-run";
      };

      ignores = [
        "*.swp"
        "*~"
        ".DS_Store"
        ".direnv/"
        "result"
        "result-*"
      ];
    };
  };
}
