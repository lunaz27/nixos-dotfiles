{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.services.sunshine;
in
{
  options = {
    modules.core.services.sunshine = {
      enable = lib.mkEnableOption "game streaming host for moonlight";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      settings = {
        sunshine_name = "NixOS-Desktop";
        upnp = "disabled";
        gamepad = "xone";
        min_log_level = "info";
      };

      # applications = {
      #   apps = [
      #
      #   ];
      # };
    };
  };
}
