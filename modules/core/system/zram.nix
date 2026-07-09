{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.zram.enable = lib.mkEnableOption "enables zram";
  };

  config = lib.mkIf config.modules.core.zram.enable {
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
