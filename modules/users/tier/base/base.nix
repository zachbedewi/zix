{ self, ... }: {
  flake.modules.homeManager.base = {
    imports = with self.modules.homeManager; [
      home-directory

      xdg
      sops

      shellAliases
      zsh
      bash

      starship

      git
      eza
      fzf
      zoxide
      direnv
      delta
    ];

    home.stateVersion = "26.05";
  };
}
