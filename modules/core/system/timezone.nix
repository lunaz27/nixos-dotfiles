{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.system.timezone;
in
{
  options = {
    modules.core.system.timezone = {
      enable = lib.mkEnableOption "hcm timezone" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "Asia/Ho_Chi_Minh";
  };
}
