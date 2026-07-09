{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.portals.enable = lib.mkEnableOption "niri gnome portal";
  };

  config = lib.mkIf config.modules.core.portals.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];

      config.common.default = "*";
    };
  };
}
