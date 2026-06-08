{ inputs, ... }:
{
  flake.modules.nixos.eye-of-god =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [ zach ];

      home-manager.users.zach = {
        ###
      };
    };
}
