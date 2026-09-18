{
  flake.modules.homeManager.fd = {
    programs.fd = {
      enable = true;

      ignores = [ ".git" ];
    };
  };
}
