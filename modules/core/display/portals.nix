{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.display.portals.enable =
      lib.mkEnableOption "system-level portals linking for home manager";
  };

  config = lib.mkIf config.modules.core.display.portals.enable {
    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];
  };
}
