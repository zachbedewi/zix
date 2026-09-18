{ self, lib, ... }: {
  flake.modules = {
    nixos = lib.mapAttrs (name: traits: { lib, pkgs, ... }: {
      users.users.${name} = {
        isNormalUser = true;
        home = "/home/${name}";
        extraGroups = lib.optionals (traits.admin or false) [ "wheel" ];
        shell = pkgs.zsh;
      };
      programs.zsh.enable = true;

      home-manager.users.${name}.imports = [ self.modules.homeManager.${name} ];
    }) self.users;

    darwin = lib.mapAttrs (name: traits: { lib, pkgs, ... }: {
      users.users.${name} = {
        home = "/Users/${name}";
        shell = pkgs.zsh;
      };
      programs.zsh.enable = true;

      home-manager.users.${name}.imports = [ self.modules.homeManager.${name} ];

      system.primaryUser = lib.mkIf (traits.admin or false) name;
    }) self.users;

    homeManager = lib.mapAttrs (name: _: { home.username = name; }) self.users;
  };
}
