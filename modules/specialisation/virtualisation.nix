{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.specialisation.virtualisation;
in
{
  options = {
    modules.specialisation.virtualisation = {
      enable = lib.mkEnableOption "virtualisation boot specialisation";

      features = {
        gui = lib.mkEnableOption "uses virt-manager frontend";
        windowsSupport = lib.mkEnableOption "enables windows 11, etc.";
        usbSharing = lib.mkEnableOption "shared usb with host";
        clipboardSharing = lib.mkEnableOption "shared clipboard content";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    specialisation."Virtualisation".configuration = {
      system.nixos.tags = [ "Virtualisation" ];

      modules.core.services.qemu = {
        enable = lib.mkForce true;

        features = {
          gui = lib.mkForce cfg.features.gui;
          windowsSupport = lib.mkForce cfg.features.windowsSupport;
          usbSharing = lib.mkForce cfg.features.usbSharing;
          clipboardSharing = lib.mkForce cfg.features.clipboardSharing;
        };
      };
    };
  };
}
