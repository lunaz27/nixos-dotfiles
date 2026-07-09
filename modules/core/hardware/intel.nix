{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.intel.enable = lib.mkEnableOption "intel cpu";
  };

  config = lib.mkIf config.modules.core.intel.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
