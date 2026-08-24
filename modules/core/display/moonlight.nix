{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.display.moonlight;
in
{
  options = {
    modules.core.display.moonlight = {
      enable = lib.mkEnableOption "client for playing PC games (desktop host)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.moonlight-qt = {
      enable = true;
      capSysNice = true;
    };
  };
}
