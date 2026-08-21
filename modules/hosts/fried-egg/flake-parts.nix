{ zix-lib, ... }: { flake.nixosConfigurations = zix-lib.mkNixos "x86_64-linux" "fried-egg"; }
