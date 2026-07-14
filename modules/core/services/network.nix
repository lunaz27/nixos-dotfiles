{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.services.network.enable = lib.mkEnableOption "hostname + networkmanager";
  };

  config = lib.mkIf config.modules.core.services.network.enable {
    networking = {
      hostName = "NixOS";
      networkmanager.enable = true;
    };

    # TODO: Add toggleable option for broken DNS wifi
    networking.networkmanager.appendNameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
