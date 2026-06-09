{ inputs, ... }: { flake.homeConfigurations = inputs.self.zix-lib.mkHomeManager "x86_64-linux" "zach" { }; }
