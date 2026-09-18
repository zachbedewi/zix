{
  flake.modules.homeManager.firefox =
    { lib, pkgs, ... }:
    let
      package = pkgs.nur.repos.rycee.firefox-addons.ublock-origin;

      # Curated third-party subscriptions, on top of uBlock's own defaults.
      # https://github.com/SpitFire-666/Firefox-Stuff#-recommended-ublock-filters
      customFilterLists = [
        # Blocks/removes copycat search-result sites (DuckDuckGo, Google, etc).
        "https://raw.githubusercontent.com/quenhus/uBlock-Origin-dev-filter/main/dist/all_search_engines/all.txt"
        # Removes cookie-consent popups.
        "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
        # Replacement for the discontinued Bypass Paywalls Clean addon.
        "https://gitlab.com/magnolia1234/bypass-paywalls-clean-filters/-/raw/main/bpc-paywall-filter.txt"
        # Strips tracking/junk parameters (UTM, AMP links, etc) from URLs.
        "https://gitlab.com/DandelionSprout/adfilt/-/raw/master/LegitimateURLShortener.txt"
        # Removes "Open in App" mobile prompts.
        "https://secure.fanboy.co.nz/fanboy-mobile-notifications.txt"
      ];
    in
    {
      zix.firefox.extensions.${package.addonId} = {
        inherit package;

        settings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
          ]
          ++ customFilterLists;

          # `importedLists`/`externalLists` are how uBlock tracks which
          # `selectedFilterLists` entries are custom subscriptions rather
          # than one of its stock lists; both must stay in sync with the
          # custom entries above.
          importedLists = customFilterLists;
          externalLists = lib.concatStringsSep "\n" customFilterLists;
        };
      };
    };
}
