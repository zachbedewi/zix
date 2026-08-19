let
  time = { lib, ... }: { time.timeZone = lib.mkDefault "America/Chicago"; };
in
{
  flake.modules = {
    nixos.locale = {
      imports = [ time ];

      i18n.defaultLocale = "en_US.UTF-8";

      console.keyMap = "us";
    };

    darwin.locale = time;
  };
}
