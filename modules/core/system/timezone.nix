{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.timezone.enable = lib.mkEnableOption "hcm timezone";
  };

  config = lib.mkIf config.modules.core.timezone.enable {
    time.timeZone = "Asia/Ho_Chi_Minh";
  };
}
