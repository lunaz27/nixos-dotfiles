{
  lib,
  config,
  pkgs,
  userEmail,
  ...
}:

{
  options = {
    modules.user.apps.anki.enable = lib.mkEnableOption "anki - spaced repetition flashcard program";
  };

  config = lib.mkIf config.modules.user.apps.anki.enable {
    sops.secrets."user-1" = {
      sopsFile = ../../../secrets/user-level/anki-keys.yaml;
    };

    programs.anki = {
      enable = true;
      addons = with pkgs.ankiAddons; [
        anki-connect
        review-heatmap
        ajt-card-management

        # NOTE: When add-on is not available in nixpkgs
        # (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        #   pname = "recolor";
        #   version = "3.1";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "AnKing-VIP";
        #     repo = "AnkiRecolor";
        #     rev = finalAttrs.version;
        #     sparseCheckout = [ "src/addon" ];
        #     hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
        #   };
        #   sourceRoot = "${finalAttrs.src.name}/src/addon";
        # }))
      ];

      hideTopBar = true;
      # hideBottomBar = true;
      answerKeys = [
        {
          ease = 1;
          key = "h";
        }
        {
          ease = 2;
          key = "j";
        }
        {
          ease = 3;
          key = "k";
        }
        {
          ease = 4;
          key = "l";
        }
      ];

      profiles."user-1" = {
        default = true;

        sync = {
          username = userEmail;
          keyFile = config.sops.secrets."user-1".path;
          autoSync = true;
          syncMedia = true;
        };
      };
    };
  };
}
