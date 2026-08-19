{ self, ... }: {
  flake.modules = {
    nixos.base = {
      imports = with self.modules.nixos; [
        minimal

        system-packages

        ssh
        sudo
        firmware
        networking
        home-manager
        sops

        desktops
      ];
    };

    darwin.base = {
      imports = with self.modules.darwin; [
        minimal

        system-packages

        ssh
        sudo
        home-manager
        sops

        homebrew
      ];
    };

    homeManager.base = {
      imports = with self.modules.homeManager; [
        home-directory

        xdg
        secrets

        shell-aliases
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
  };
}
