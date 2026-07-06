{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.kernel-latest.enable = lib.mkEnableOption "latest kernel pkg";
  };

  config = lib.mkIf config.modules.core.kernel-latest.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
