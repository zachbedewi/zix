let
  defaults = {
    security.sudo.extraConfig = ''
      Defaults lecture = never
      Defaults timestamp_timeout = 15
      Defaults timestamp_type = global
    '';
  };
in
{
  flake.modules = {
    nixos.sudo = {
      imports = [ defaults ];

      security.sudo.execWheelOnly = true;
    };

    darwin.sudo = {
      imports = [ defaults ];

      security.pam.services.sudo_local.touchIdAuth = true;
    };
  };
}
