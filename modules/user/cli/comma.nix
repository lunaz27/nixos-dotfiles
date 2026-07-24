{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.user.cli.comma;
in
{
  imports = [
    inputs.nix-index-database.homeModules.default
  ];

  options = {
    modules.user.cli.comma = {
      enable = lib.mkEnableOption "run programs without installing through prefix ,";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index = {
        enable = true;

        enableFishIntegration = config.modules.user.shells.fish.enable;
        enableBashIntegration = true;
      };

      nix-index-database.comma = {
        enable = true;
      };
    };
  };
}
