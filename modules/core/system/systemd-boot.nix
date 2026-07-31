{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.system.systemd-boot;
in
{
  options = {
    modules.core.system.systemd-boot = {
      enable = lib.mkEnableOption "systemd boot loader" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        editor = false; # Avoiding root access with init=/bin/sh
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
