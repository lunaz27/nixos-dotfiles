{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.services.enable = lib.mkEnableOption "quality-of-life services";
  };

  config = lib.mkIf config.modules.core.services.enable {
    # NOTE: Dependencies for noctalia-shell
    services = {
      # Hardware power profiles
      power-profiles-daemon.enable = true;

      # Power state monitoring
      upower.enable = true;

      # Virtual fs (i.e. USBs, Trash, etc.)
      gvfs.enable = true;
    };
  };
}
