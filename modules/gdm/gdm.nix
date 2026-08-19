{ flake.modules.nixos.gdm = { config, lib, ... }: lib.mkIf (config.zix.greeter == "gdm") { services.displayManager.gdm.enable = true; }; }
