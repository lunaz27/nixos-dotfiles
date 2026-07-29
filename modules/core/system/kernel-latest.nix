{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.core.system.kernel-latest;
in
{
  options = {
    modules.core.system.kernel-latest = {
      enable = lib.mkEnableOption "latest kernel pkg" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
