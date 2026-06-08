_: {
  flake.modules = {
    darwin.gh = {
      sops.secrets.gh_token = { };
    };

    nixos.gh = {
      sops.secrets.gh_token = { };
    };

    homeManager.gh = _: {
      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };

      programs.zsh.initContent = ''
        export GH_TOKEN="$(cat /run/secrets/gh_token 2>/dev/null)"
      '';
    };
  };
}
