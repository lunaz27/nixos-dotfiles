{
  lib,
  config,
  hostName,
  ...
}:

let
  cfg = config.modules.core.services.network;
in
{
  options = {
    modules.core.services.network = {
      enable = lib.mkEnableOption "declare hostname with networkmanager" // {
        default = true;
      };
      isRouterDnsBroken = lib.mkEnableOption "insert cloudflare + google dns at /etc/resolv.conf";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      inherit hostName;

      networkmanager = {
        enable = true;
        insertNameservers = lib.mkIf cfg.isRouterDnsBroken [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
  };
}
