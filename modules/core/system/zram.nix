{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.system.zram;
in
{
  options = {
    modules.core.system.zram.enable = lib.mkEnableOption "enables zram" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    zramSwap = {
      enable = true;

      priority = 100;
      # NOTE: See list of supported algorithm:
      #       $ cat /sys/class/block/zram*/comp_algorithm
      # algorithm = "zstd";
      # memoryPercent = 50;
    };
  };
}
