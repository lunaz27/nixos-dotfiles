{
  lib,
  config,
  pkgs,
  # pkgs-stable,
  userName,
  ...
}:

{
  options = {
    modules.core.display.elyprismlauncher.enable =
      lib.mkEnableOption "minecraft launcher with ely.by and local accounts";
  };

  config = lib.mkIf config.modules.core.display.elyprismlauncher.enable {
    environment.systemPackages = with pkgs; [
      elyprismlauncher

      (pkgs.makeDesktopItem {
        name = "monifactory";
        desktopName = "Monifactory";
        type = "Application";
        exec = "${pkgs.elyprismlauncher}/bin/elyprismlauncher --launch Monifactory";
        icon = "/home/${userName}/.local/share/ElyPrismLauncher/instances/Monifactory/icon.png";
        comment = "Play this game on elyprismlauncher";
        categories = [
          "Game"
          "ActionGame"
          "AdventureGame"
          "Simulation"
        ];
      })
    ];

    nixpkgs.overlays = [
      # WARN: Temporary fix for launcher not recognizing mesa (amd)
      # (self: super: {
      #   inherit (pkgs-stable) mesa;
      # })

      (final: prev: {
        elyprismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
          pname = "elyprismlauncher";

          src = pkgs.fetchFromGitHub {
            owner = "ElyPrismLauncher";
            repo = "Launcher";
            tag = oldAttrs.version;
            hash = "sha256-0+aK0hR7MO5w7AhEcX+QQ4CyxrkOtUyUDm5R0tUEpkQ=";
          };
        });

        elyprismlauncher =
          (prev.prismlauncher.override {
            prismlauncher-unwrapped = final.elyprismlauncher-unwrapped;
          }).overrideAttrs
            (oldAttrs: {
              pname = "elyprismlauncher";

              qtWrapperArgs = map (
                arg:
                builtins.replaceStrings
                  [
                    "bin/prismlauncher"
                    "PRISMLAUNCHER_JAVA_PATHS"
                  ]
                  [
                    "bin/elyprismlauncher"
                    "PINECONEMC_JAVA_PATHS"
                  ]
                  arg
              ) oldAttrs.qtWrapperArgs;
            });
      })
    ];
  };
}
