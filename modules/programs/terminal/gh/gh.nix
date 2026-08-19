_: {
  flake.modules.homeManager.gh = { config, ... }: {
    zix.secrets.gh_token = { };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    programs.zsh.initContent = ''
      [[ -r ${config.zix.secrets.gh_token.path} ]] &&
        export GH_TOKEN="$(cat ${config.zix.secrets.gh_token.path})"
    '';
  };
}
