{
  flake.modules.homeManager.home-directory =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.homeDirectory = if pkgs.stdenv.isDarwin then (lib.mkForce "/Users/${config.home.username}") else "/home/${config.home.username}";
    };
}
