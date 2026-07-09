{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.global-pkgs.enable = lib.mkEnableOption "environment pkgs";
  };

  config = lib.mkIf config.modules.core.global-pkgs.enable {
    environment.systemPackages = with pkgs; [
      just

      wget
      curl
    ];
  };
}
