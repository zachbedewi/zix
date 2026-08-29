{
  flake.modules.homeManager.git = {
    zix.shellAliases = {
      gl = "git log";
      gs = "git status";

      ga = "git add";
      gc = "git commit";

      gp = "git push";
      gpl = "git pull";

      gd = "git diff";
      gds = "git diff --staged";
    };

    programs.git = {
      enable = true;

      settings = {
        user.name = "Zach Bedewi";
        user.email = "zachary.bedewi@protonmail.com";

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
