{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.network.enable = lib.mkEnableOption "hostname + networkmanager";
  };

  config = lib.mkIf config.modules.core.network.enable {
    networking = {
      hostName = "NixOS";

      networkmanager.enable = true;
    };
  };
}
