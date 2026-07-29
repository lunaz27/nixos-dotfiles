{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkForce;

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
        enable = mkForce true;

        features = {
          gui = mkForce cfg.features.gui;
          windowsSupport = mkForce cfg.features.windowsSupport;
          usbSharing = mkForce cfg.features.usbSharing;
          clipboardSharing = mkForce cfg.features.clipboardSharing;
        };
      };
    };
  };
}
