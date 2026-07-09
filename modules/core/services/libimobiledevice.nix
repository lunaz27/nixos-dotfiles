{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.libimobiledevice.enable = lib.mkEnableOption "apple devices support";
  };

  config = lib.mkIf config.modules.core.libimobiledevice.enable {
    services.usbmuxd.enable = true;

    # NOTE: Mounting iphone using `$ idevicepair pair`
    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse

      appimage-run # Sidestore AppImage
    ];
  };
}
