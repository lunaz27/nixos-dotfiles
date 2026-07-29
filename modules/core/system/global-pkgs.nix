{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.core.system.global-pkgs;
in
{
  options = {
    modules.core.system.global-pkgs = {
      enable = lib.mkEnableOption "environment pkgs" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      just

      wget
      curl
    ];
  };
}
