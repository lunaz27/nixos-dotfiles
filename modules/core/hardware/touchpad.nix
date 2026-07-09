{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.touchpad.enable = lib.mkEnableOption "touchpad support";
  };

  config = lib.mkIf config.modules.core.touchpad.enable {
    services.libinput.enable = true;
  };
}
