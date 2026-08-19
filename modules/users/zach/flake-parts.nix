{ zix-lib, ... }: { flake.homeConfigurations = zix-lib.mkHomeManager "x86_64-linux" "zach"; }
