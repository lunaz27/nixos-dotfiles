{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.btrfs.enable = lib.mkEnableOption "btrfs autoscrub";
  };

  config = lib.mkIf config.modules.core.btrfs.enable {
    services.btrfs.autoScrub = {
      enable = true;

      interval = "weekly";
      fileSystems = [ "/" ];
    };
  };
}
