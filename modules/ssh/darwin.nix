{
  flake.modules.darwin.ssh = {
    services.openssh = {
      enable = true;
    };
  };
}
