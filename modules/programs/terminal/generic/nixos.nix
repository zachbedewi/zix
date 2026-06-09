{ flake.modules.nixos.genericPackages = { pkgs, ... }: { environment.systemPackages = with pkgs; [ parted ]; }; }
