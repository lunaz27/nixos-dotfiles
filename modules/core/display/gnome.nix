{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.display.gnome.enable = lib.mkEnableOption "gnome - desktop environment";
  };

  config = lib.mkIf config.modules.core.display.gnome.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.variables = {
      XMODIFIERS = lib.mkForce "@im=ibus";
    };
  };
}
