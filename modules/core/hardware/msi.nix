{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.hardware.msi;
in
{
  options = {
    modules.core.hardware.msi = {
      enable = lib.mkEnableOption "msi laptop specific settings";

      ec.preset = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "eco"
            "comfort"
            "turbo"
          ]
        );
        default = null;
        description = "hardware shift mode for msi-ec module";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [
        "msi-ec"
      ];

      extraModulePackages = [
        config.boot.kernelPackages.msi-ec
      ];

      kernelParams = [
        "nvme.noacpi=1"
        "video.report_key_events=0"
      ];
    };

    systemd.tmpfiles.rules = [
      "w /sys/class/power_supply/BAT1/charge_control_start_threshold - - - - 70"
      "w /sys/class/power_supply/BAT1/charge_control_end_threshold - - - - 80"
    ]
    ++ lib.optionals (cfg.ec.preset != null) (
      builtins.concatLists [
        [
          "w /sys/devices/platform/msi-ec/shift_mode - - - - ${cfg.ec.preset}"
        ]

        {
          eco = [
            "w /sys/devices/platform/msi-ec/webcam_block - - - - on"
            "w /sys/devices/platform/msi-ec/leds/msiacpi::kbd_backlight/brightness - - - - 0"
          ];
          comfort = [
            "w /sys/devices/platform/msi-ec/webcam_block - - - - off"
            "w /sys/devices/platform/msi-ec/leds/msiacpi::kbd_backlight/brightness - - - - 3"
          ];
          turbo = [
            "w /sys/devices/platform/msi-ec/webcam_block - - - - off"
            "w /sys/devices/platform/msi-ec/leds/msiacpi::kbd_backlight/brightness - - - - 3"
          ];
        }
        .${cfg.ec.preset}
      ]
    );
  };
}
