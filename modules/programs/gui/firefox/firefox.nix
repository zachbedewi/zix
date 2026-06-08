{ inputs, ... }:
{
  flake.modules = {
    darwin.firefox =
      { pkgs, ... }:
      let
        configJs = "${inputs.fx-autoconfig}/program/config.js";
        configPrefsJs = "${inputs.fx-autoconfig}/program/defaults/pref/config-prefs.js";
        firefoxApp = "/Applications/Firefox.app";
        resourcesDir = "${firefoxApp}/Contents/Resources";

        patchScript = pkgs.writeShellScript "patch-firefox-autoconfig" ''
          set -euo pipefail

          RESOURCES="${resourcesDir}"
          LOG="$HOME/Library/Logs/firefox-autoconfig.log"

          log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG"; }

          if [ ! -d "${firefoxApp}" ]; then
            log "Firefox.app not found at ${firefoxApp}"
            exit 0
          fi

          if ! cmp -s "${configJs}" "$RESOURCES/config.js" 2>/dev/null; then
            cp "${configJs}" "$RESOURCES/config.js"
            log "Installed config.js"
          fi

          mkdir -p "$RESOURCES/defaults/pref"
          if ! cmp -s "${configPrefsJs}" "$RESOURCES/defaults/pref/config-prefs.js" 2>/dev/null; then
            cp "${configPrefsJs}" "$RESOURCES/defaults/pref/config-prefs.js"
            log "Installed config-prefs.js"
          fi

          log "Firefox autoconfig patch verified"
        '';
      in
      {
        nixpkgs.overlays = [ inputs.nur.overlays.default ];

        homebrew.casks = [ "firefox" ];

        launchd.user.agents.firefox-autoconfig = {
          serviceConfig = {
            ProgramArguments = [
              "/bin/sh"
              "-c"
              "${patchScript}"
            ];
            WatchPaths = [ firefoxApp ];
            RunAtLoad = true;
          };
        };

        system.defaults.CustomUserPreferences."org.mozilla.firefox" = {
          EnterprisePoliciesEnabled = true;
          DisableTelemetry = true;
          DisablePocket = true;
          DisableFirefoxStudies = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };
      };

    nixos.firefox = {
      nixpkgs.overlays = [ inputs.nur.overlays.default ];
    };

    homeManager.firefox =
      { pkgs, lib, ... }:
      let
        isDarwin = pkgs.stdenv.isDarwin;
        profileBase =
          if isDarwin then "Library/Application Support/Firefox/Profiles" else ".mozilla/firefox";

        addons = pkgs.nur.repos.rycee.firefox-addons;

        defaultExtensions = with addons; [
          ublock-origin
          clearurls
          multi-account-containers
          cookie-autodelete
          skip-redirect
          localcdn
          sidebery
          tridactyl
          bitwarden
          darkreader
          stylus
        ];

        commonSettings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
          "extensions.autoDisableScopes" = 0;
          "browser.tabs.inTitlebar" = 1;
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "intl.regional_prefs.use_os_locales" = true;
        };

        searchConfig = {
          force = true;
          default = "ddg";
          order = [
            "DuckDuckGo"
            "Nix Packages"
            "NixOS Options"
            "GitHub"
            "MDN"
          ];
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "https://nixos.org/favicon.png";
              definedAliases = [ "@np" ];
            };

            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "https://nixos.org/favicon.png";
              definedAliases = [ "@no" ];
            };

            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master";
                    }
                  ];
                }
              ];
              definedAliases = [ "@hm" ];
            };

            "GitHub" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "type";
                      value = "repositories";
                    }
                  ];
                }
              ];
              icon = "https://github.com/favicon.ico";
              definedAliases = [ "@gh" ];
            };

            "MDN" = {
              urls = [
                {
                  template = "https://developer.mozilla.org/en-US/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@mdn" ];
            };

            "Crates.io" = {
              urls = [
                {
                  template = "https://crates.io/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@cr" ];
            };

            "docs.rs" = {
              urls = [
                {
                  template = "https://docs.rs/releases/search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@rs" ];
            };

            "YouTube" = {
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@yt" ];
            };

            "Wikipedia" = {
              urls = [
                {
                  template = "https://en.wikipedia.org/wiki/Special:Search";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@w" ];
            };

            "Google".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };

        containerConfig = {
          Work = {
            id = 1;
            color = "blue";
            icon = "briefcase";
          };
          Personal = {
            id = 2;
            color = "green";
            icon = "circle";
          };
          Shopping = {
            id = 3;
            color = "orange";
            icon = "cart";
          };
          Banking = {
            id = 4;
            color = "purple";
            icon = "dollar";
          };
          Social = {
            id = 5;
            color = "yellow";
            icon = "vacation";
          };
        };

        bookmarkConfig = {
          force = true;
          settings = [
            {
              name = "Toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "GitHub";
                  url = "https://github.com";
                }
                {
                  name = "Nix Search";
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "HM Options";
                  url = "https://nix-community.github.io/home-manager/options.xhtml";
                }
                {
                  name = "HN";
                  url = "https://news.ycombinator.com";
                }
                {
                  name = "Lobsters";
                  url = "https://lobste.rs";
                }
                {
                  name = "Reddit";
                  url = "https://old.reddit.com";
                }
                {
                  name = "Dev";
                  bookmarks = [
                    {
                      name = "MDN";
                      url = "https://developer.mozilla.org";
                    }
                    {
                      name = "docs.rs";
                      url = "https://docs.rs";
                    }
                    {
                      name = "crates.io";
                      url = "https://crates.io";
                    }
                    {
                      name = "Go Docs";
                      url = "https://pkg.go.dev";
                    }
                    {
                      name = "PyPI";
                      url = "https://pypi.org";
                    }
                  ];
                }
                {
                  name = "Nix";
                  bookmarks = [
                    {
                      name = "Nixpkgs";
                      url = "https://github.com/NixOS/nixpkgs";
                    }
                    {
                      name = "NixOS Wiki";
                      url = "https://wiki.nixos.org";
                    }
                    {
                      name = "Discourse";
                      url = "https://discourse.nixos.org";
                    }
                    {
                      name = "Flake Parts";
                      url = "https://flake.parts";
                    }
                  ];
                }
              ];
            }
          ];
        };

        mkProfile =
          {
            id,
            preConfig ? "",
            extraSettings ? { },
          }:
          {
            inherit id;
            isDefault = id == 0;
            inherit preConfig;
            settings = commonSettings // extraSettings;
            extensions.packages = defaultExtensions;
            search = searchConfig;
            containersForce = true;
            containers = containerConfig;
            bookmarks = bookmarkConfig;
            userChrome = builtins.readFile ./css/userChrome.css;
            userContent = builtins.readFile ./css/userContent.css;
          };

        selectedScripts = [
          "autoHideNavbarSupport.uc.js"
          "extensionOptionsPanel.uc.js"
          "updateNotificationSlayer.sys.mjs"
        ];

        mkChromeDir =
          profileName:
          let
            base = "${profileBase}/${profileName}/chrome";
          in
          {
            "${base}/utils/boot.sys.mjs".source = "${inputs.fx-autoconfig}/profile/chrome/utils/boot.sys.mjs";
            "${base}/utils/fs.sys.mjs".source = "${inputs.fx-autoconfig}/profile/chrome/utils/fs.sys.mjs";
            "${base}/utils/utils.sys.mjs".source = "${inputs.fx-autoconfig}/profile/chrome/utils/utils.sys.mjs";
            "${base}/utils/uc_api.sys.mjs".source =
              "${inputs.fx-autoconfig}/profile/chrome/utils/uc_api.sys.mjs";
            "${base}/utils/module_loader.mjs".source =
              "${inputs.fx-autoconfig}/profile/chrome/utils/module_loader.mjs";
            "${base}/utils/chrome.manifest".source =
              "${inputs.fx-autoconfig}/profile/chrome/utils/chrome.manifest";

            "${base}/csshacks".source = inputs.firefox-csshacks;
          }
          // builtins.listToAttrs (
            map (script: {
              name = "${base}/JS/${script}";
              value = {
                source = "${inputs.uc-scripts}/JS/${script}";
              };
            }) selectedScripts
          );

        profiles = [
          "arkenfox"
          "betterfox"
          "vanilla"
        ];
      in
      {
        programs.firefox = {
          enable = true;

          package =
            if isDarwin then
              null
            else
              pkgs.firefox.override { extraPrefs = builtins.readFile ./autoconfig-bootstrap.js; };

          policies = lib.mkIf (!isDarwin) {
            DisableTelemetry = true;
            DisablePocket = true;
            DisableFirefoxStudies = true;
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
          };

          profiles = {
            arkenfox = mkProfile {
              id = 0;
              preConfig = builtins.readFile "${inputs.arkenfox}/user.js";
              extraSettings = {
                "keyword.enabled" = true;
                "browser.search.suggest.enabled" = true;
                "browser.urlbar.suggest.searches" = true;
                "browser.startup.page" = 3;
                "privacy.resistFingerprinting" = false;
                "privacy.resistFingerprinting.letterboxing" = false;
                "webgl.disabled" = false;
                "media.eme.enabled" = true;
                "network.http.referer.XOriginPolicy" = 0;
                "network.http.referer.XOriginTrimmingPolicy" = 2;
                "privacy.clearOnShutdown.history" = false;
                "privacy.clearOnShutdown.cookies" = false;
                "privacy.clearOnShutdown.cache" = false;
                "privacy.clearOnShutdown.formdata" = false;
                "privacy.clearOnShutdown.sessions" = false;
                "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
                "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
                "network.dns.disableIPv6" = false;
                "network.prefetch-next" = true;
                "network.dns.disablePrefetch" = false;
                "network.predictor.enabled" = true;
                "media.autoplay.default" = 1;
                "gfx.webrender.all" = true;
                "layers.acceleration.force-enabled" = true;
              };
            };

            betterfox = mkProfile {
              id = 1;
              preConfig = builtins.readFile "${inputs.betterfox}/user.js";
              extraSettings = {
                "browser.startup.page" = 3;
                "gfx.webrender.all" = true;
                "layers.acceleration.force-enabled" = true;
                "general.smoothScroll" = true;
              };
            };

            vanilla = mkProfile {
              id = 2;
              extraSettings = {
                "browser.startup.page" = 3;
              };
            };
          };
        };

        home.file = lib.mkMerge (
          (map mkChromeDir profiles)
          ++ [
            (lib.mkIf isDarwin {
              "Library/Application Support/Mozilla/NativeMessagingHosts/tridactyl.json".source =
                "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
            })
          ]
        );

        programs.firefox.nativeMessagingHosts = lib.mkIf (!isDarwin) [ pkgs.tridactyl-native ];

        xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;
      };
  };
}
