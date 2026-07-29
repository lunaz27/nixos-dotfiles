{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.hardware.amd-gpu.enable = lib.mkEnableOption "AMD GPU Extra drivers/utils";
  };

  config = lib.mkIf config.modules.core.hardware.amd-gpu.enable {
    hardware.amdgpu = {
      initrd.enable = true;

      # Optional
      opencl.enable = true;
      # zluda.enable = true;
    };

    environment.systemPackages = with pkgs.rocmPackages; [
      amdsmi
    ];

    # Linux MSI Afterburner
    services.lact.enable = false;

    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
