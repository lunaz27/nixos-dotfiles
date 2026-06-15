{
  flake.homeModules."anki" =
    {
      pkgs,
      ...
    }:

    {
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
            username = "nguyenducthientan09@gmail.com";
            # HACK:
            # - Navigate to the sync settings page. (Tools > Preferences > Syncing)
            # - Log in to your AnkiWeb account.
            # - Select "Yes" to the prompt about saving preferences and syncing.
            # - A Home Manager warning prompt will show. Select "Show details...".
            # - Get your sync key from the message: "syncKey changed from \`None\` to \`<YOUR SYNC KEY WILL BE HERE>\`"
            keyFile = "/home/suwapotta/Private/.anki_key";

            autoSync = true;
            syncMedia = true;
          };
        };
      };
    };
}
