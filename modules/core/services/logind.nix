{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.services.logind;
in
{
  options = {
    modules.core.services.logind = {
      enable = lib.mkEnableOption "controls how laptop behaves when closing lid";
      ignoreLidClosing = lib.mkEnableOption "does not suspend when closing laptop lid";
    };
  };

  config = lib.mkIf cfg.enable {
    services.logind.settings.Login = {
      HandleLidSwitch = if cfg.ignoreLidClosing then "ignore" else "poweroff";
      HandleLidSwitchExternalPower = if cfg.ignoreLidClosing then "ignore" else "lock";
      HandleLidSwitchDocked = "ignore";
    };
  };
}
