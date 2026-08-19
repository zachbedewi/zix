{ self, ... }: {
  flake.modules.nixos.eye-of-god = {
    imports = with self.modules.nixos; [ zach ];
  };
}
