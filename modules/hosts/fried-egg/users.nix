{ self, ... }:

{
  flake.modules.nixos.fried-egg = {
    imports = with self.modules.nixos; [ zach ];
  };

}
