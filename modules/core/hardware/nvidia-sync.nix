{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.hardware.nvidia-sync.enable = lib.mkEnableOption "uses nvidia GPU entirely";
  };

  config = lib.mkIf config.modules.core.hardware.nvidia-sync.enable {
    hardware.nvidia = {
      prime = {
        sync.enable = true;

        offload = {
          enable = false;
          enableOffloadCmd = false;
        };
      };

      powerManagement.finegrained = false;
    };

    environment = {
      sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
  };
}
