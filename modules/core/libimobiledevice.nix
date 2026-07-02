{
  flake.nixosModules."libimobiledevice" =
    {
      pkgs,
      ...
    }:

    {
      services.usbmuxd.enable = true;

      # NOTE: Mounting iphone using `$ idevicepair pair`
      environment.systemPackages = with pkgs; [
        libimobiledevice
        ifuse

        appimage-run # Sidestore AppImage
      ];
    };
}
