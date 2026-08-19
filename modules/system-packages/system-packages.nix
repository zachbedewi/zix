let
  common = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      home-manager
    ];
  };

  nixos = { pkgs, ... }: { environment.systemPackages = with pkgs; [ parted ]; };

  darwin = { pkgs, ... }: { environment.systemPackages = with pkgs; [ mas ]; };
in
{
  flake.modules = {
    nixos.system-packages = {
      imports = [
        common
        nixos
      ];
    };

    darwin.system-packages = {
      imports = [
        common
        darwin
      ];
    };
  };
}
