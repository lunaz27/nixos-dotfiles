{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.core.services.power;
in
{
  options = {
    modules.core.services.power = {
      enable = lib.mkEnableOption "collection of power daemons";
      mode = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "power-saver"
            "balanced"
            "performance"
          ]
        );
        default = null;
        description = "wether to enable systemd services for power-profiles-daemon";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    systemd.services."force-power-profiles" = lib.mkIf (cfg.mode != null) {
      enable = true;
      description = "Force power-profiles-daemon to use ${cfg.mode} profile";
      after = [ "power-profiles-daemon.service" ];
      wantedBy = [ "multi-user.target" ];
      requires = [ "power-profiles-daemon.service" ];

      path = [ pkgs.power-profiles-daemon ];
      script = ''
        sleep 3
        powerprofilesctl set ${cfg.mode}
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
