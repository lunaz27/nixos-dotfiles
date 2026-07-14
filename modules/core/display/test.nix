{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.elyprismlauncher;
in
{
  options = {
    modules.elyprismlauncher = {
      enable = lib.mkEnableOption "enables switch" // {
        default = true;
      };
      # option2 = lib.mkOption { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      elyprismlauncher
    ];

    nixpkgs.overlays = [
      (final: prev: {
        elyprismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
          pname = "elyprismlauncher";

          src = pkgs.fetchFromGitHub {
            owner = "ElyPrismLauncher";
            repo = "Launcher";
            tag = oldAttrs.version;
            hash = "sha256-5xtunjHgzVsA4X+ih3S3X9czJ4YqdqygfqWQm3h3j+c=";
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
                  [ "bin/prismlauncher" "PRISMLAUNCHER_JAVA_PATHS" ]
                  [ "bin/elyprismlauncher" "PINECONEMC_JAVA_PATHS" ]
                  arg
              ) oldAttrs.qtWrapperArgs;
            });
      })
    ];
  };
}
