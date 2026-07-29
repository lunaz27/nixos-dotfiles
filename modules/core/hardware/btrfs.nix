{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.hardware.btrfs;
in
{
  options = {
    modules.core.hardware.btrfs = {
      enable = lib.mkEnableOption "btrfs autoscrub" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.btrfs.autoScrub = {
      enable = true;

      interval = "weekly";
      fileSystems = [ "/" ];
    };
  };
}
