{
  inputs,
  ...
}:
{
  # import all essential nix-tools which are used in all modules of a specific class

  flake.modules.nixos.system-default = {
    imports =
      with inputs.self.modules.nixos;
      [
        system-minimal
        home-manager
        sops
      ]
      ++ (with inputs.self.modules.generic; [
        systemConstants
      ]);
  };

  flake.modules.darwin.system-default = {
    imports =
      with inputs.self.modules.darwin;
      [
        system-minimal
        home-manager
        homebrew
      ]
      ++ (with inputs.self.modules.generic; [
        systemConstants
      ]);
  };

  # impermanence is not added by default to home-manager, because of missing darwin implementation
  # for linux home-manager stand-alone configurations it has to be added manually

  flake.modules.homeManager.system-default = {
    imports =
      with inputs.self.modules.homeManager;
      [
        system-minimal

        xdg
      ]
      ++ [ inputs.self.modules.generic.systemConstants ];
  };
}
