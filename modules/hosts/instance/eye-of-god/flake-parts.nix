{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.zix-lib.mkNixos "x86_64-linux" "eye-of-god" { };
}
