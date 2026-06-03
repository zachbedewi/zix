{
  inputs,
  ...
}:
{
  # expansion of default system with basic system settings and cli-tools

  flake.modules.nixos.system-cli = {
    imports = with inputs.self.modules.nixos; [
      system-default

      ssh
      firmware
      networking
      generic
      gh
    ];
  };

  flake.modules.darwin.system-cli = {
    imports = with inputs.self.modules.darwin; [
      system-default

      ssh
      generic
      gh
    ];
  };

  flake.modules.homeManager.system-cli = {
    imports = with inputs.self.modules.homeManager; [
      system-default

      shellAliases
      zsh
      bash

      starship

      git
      gh
      eza
      fzf
      zoxide
      direnv
      delta
    ];
  };
}
