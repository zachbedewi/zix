{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    let
      package = pkgs.nur.repos.rycee.firefox-addons.localcdn;
    in
    {
      zix.firefox.extensions.${package.addonId} = { inherit package; };
    };
}
