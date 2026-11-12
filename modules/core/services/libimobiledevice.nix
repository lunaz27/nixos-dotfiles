{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.services.libimobiledevice.enable = lib.mkEnableOption "apple devices support";
  };

  config = lib.mkIf config.modules.core.services.libimobiledevice.enable {
    services.usbmuxd.enable = true;

    # NOTE: Mounting iphone using `$ idevicepair pair`
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse
    ];
  };
}
