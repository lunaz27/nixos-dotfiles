{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  # NOTE: Helper functions
  mkSearchEngine = url: icon: alias: {
    urls = [ { template = url; } ];
    inherit icon;
    definedAliases = [ alias ];
  };

  # HACK: For each machine, use different set of uuid:
  # $ uuidgen | wl-copy
  mkEssential =
    {
      url,
      position,
      id,
    }:
    {
      inherit url position id;
      isEssential = true;
    };

  mkBookmark = name: url: { inherit name url; };
in
{
  options = {
    modules.user.apps.zen-browser.enable = lib.mkEnableOption "zen-browser with declarative options";
  };

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = lib.mkIf config.modules.user.apps.zen-browser.enable {
    # Fix ``nixos-help`` command
    home.sessionVariables.BROWSER = "zen-beta";

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        NetworkPrediction = false;
        HttpsOnlyMode = "force_enabled";
        DNSOverHTTPS = {
          Enabled = true;
          Locked = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;

        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableFeedbackCommands = true;
        DisableSetDesktopBackground = true;
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          WhatsNew = false;
        };

        DisableAppUpdate = true;
        DisableSystemAddonUpdate = true;
        DontCheckDefaultBrowser = true;
      };

      profiles.default =
        let
          containers = {
            Personal = {
              color = "purple";
              icon = "fingerprint";
              id = 1;
            };

            Study = {
              color = "blue";
              icon = "briefcase";
              id = 2;
            };

            Nix = {
              color = "turquoise";
              icon = "circle";
              id = 3;
            };
          };

          spaces = {
            "Space" = {
              id = "caa434f6-8f95-4ac7-be50-f27197141f30";
              position = 1000;
            };
            "Study" = {
              id = "827c0ad8-339b-4212-be4e-ae2ce5822c32";
              icon = "🎓";
              container = containers.Study.id;
              position = 2000;
            };
            "Nix" = {
              id = "0778051e-e3d3-4c57-8fc9-f710ca78af94";
              icon = "❄️";
              container = containers.Nix.id;
              position = 3000;
            };
          };

          pins = {
            "NixOS-Dotfiles" = mkEssential {
              url = "https://github.com/suwapotta/nixos-dotfiles";
              position = 101;
              id = "ececd77f-1354-4c4b-931e-fdca3754cdeb";
            };

            "YouTube" = mkEssential {
              url = "https://www.youtube.com/";
              position = 102;
              id = "4cb898b1-2137-4c5b-8ffb-99c8dde3b777";
            };

            "Messenger" = mkEssential {
              url = "https://www.messenger.com/t/5765709533478160/";
              position = 103;
              id = "47bf06cc-8702-43e5-9b0e-d8ae6c376b33";
            };

            "FreeBSD Manual" = mkEssential {
              url = "https://docs.freebsd.org/en/books/handbook/introduction/";
              position = 201;
              id = "c95d3575-555a-4f2d-b860-0e0b999d10e4";
            };

            "LFS" = mkEssential {
              url = "https://www.linuxfromscratch.org/";
              position = 202;
              id = "626f7fc7-4b14-4d3d-a3b4-fe3e2b4c860a";
            };

            "NixDev" = mkEssential {
              url = "https://nix.dev/tutorials/nix-language";
              position = 203;
              id = "bc2939f7-40e0-46d3-8859-1cdb1c1d1dc2";
            };
          };
        in
        {
          containersForce = true;
          spacesForce = true;
          pinsForce = true;

          inherit containers spaces pins;

          extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            darkreader
            vimium
            yomitan
            youtube-nonstop
          ];

          search = {
            force = true;
            default = "ddg";
            engines = {
              "NixOS packages" =
                mkSearchEngine "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"
                  "https://wiki.nixos.org/favicon.ico"
                  "@packages";

              "NixOS options" =
                mkSearchEngine "https://search.nixos.org/options?channel=unstable&query={searchTerms}"
                  "https://wiki.nixos.org/favicon.ico"
                  "@options";

              "NixOS Wiki" =
                mkSearchEngine "https://wiki.nixos.org/w/index.php?search={searchTerms}"
                  "https://wiki.nixos.org/favicon.ico"
                  "@wiki";

              "Arch Wiki" =
                mkSearchEngine "https://wiki.archlinux.org/index.php?search={searchTerms}"
                  "https://wiki.archlinux.org/favicon.ico"
                  "@archwiki";

              "YouTube Search" =
                mkSearchEngine "https://www.youtube.com/results?search_query={searchTerms}"
                  "https://www.youtube.com/favicon.ico"
                  "@youtube";

              "My NixOS" =
                mkSearchEngine "https://mynixos.com/search?q={searchTerms}" "https://mynixos.com/favicon.ico"
                  "@mynixos";

              "Noggle" =
                mkSearchEngine "https://noogle.dev/q?term={searchTerms}" "https://noogle.dev/favicon.ico"
                  "@noggle";

              "wikipedia".metaData.hidden = true;
              "bing".metaData.hidden = true;
            };
          };

          settings = {
            "browser.contentblocking.category" = "strict";
            "browser.ctrlTab.sortByRecentlyUsed" = true;
            "extensions.autoDisableScopes" = 0;
            "extensions.pocket.enabled" = false;
            "font.default.x-western" = "sans-serif";
            "font.name.monospace.x-western" = "JetBrainsMono Nerd Font";
            "font.name.sans-serif.x-western" = "Work Sans";
            "font.name.serif.x-western" = "Work Sans";
            "general.autoScroll" = true;
            "signon.rememberSignons" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "zen.urlbar.behavior" = "float";
            "zen.welcome-screen.seen" = true;
          };

          bookmarks = {
            force = true;
            settings = [
              {
                name = "Bookmarks Toolbar";
                toolbar = true;
                bookmarks = [
                  (mkBookmark "Academic Affairs Office" "https://mybk.hcmut.edu.vn/app/")
                  (mkBookmark "Arch Linux" "https://archlinux.org/")
                  (mkBookmark "BK-LMS" "https://lms.hcmut.edu.vn/my/")
                  (mkBookmark "GitHub" "https://github.com/")
                  (mkBookmark "Gmail" "https://mail.google.com/mail/u/0/?ogbl#inbox")
                  (mkBookmark "Google Calendar" "https://calendar.google.com/calendar/u/1/r")
                  (mkBookmark "Google Gemini" "https://gemini.google.com/app")
                  (mkBookmark "Google" "https://www.google.com/")
                  (mkBookmark "HCMUT Coursewave" "https://www.hcmut-courseware.org")
                  (mkBookmark "LFS News" "https://www.linuxfromscratch.org/lfs/news.html")
                  (mkBookmark "Messenger" "https://www.messenger.com/t/5765709533478160/")
                  (mkBookmark "Motion Canvas (Docs)" "https://archive.canvascommons.io/")
                  (mkBookmark "My Bach Khoa" "https://mybk.hcmut.edu.vn/my/index.action")
                  (mkBookmark "Noggle" "https://noogle.dev/")
                  (mkBookmark "YouTube" "https://www.youtube.com/")
                  (mkBookmark "Zalo" "https://chat.zalo.me/")
                  (mkBookmark "アニメ" "https://aanime.biz/")
                ];
              }
            ];
          };

          # TODO: css files at ~/.cache/noctalia/zen-browser
          # userChrome = ...
        };
    };
  };
}
