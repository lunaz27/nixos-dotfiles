{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.system.wol;
in
{
  options = {
    modules.core.system.wol = {
      enable = lib.mkEnableOption "enables wake on lan for a network interface";
      interface = lib.mkOption {
        type = lib.types.str;
        default = "enp16s0";
        description = "the network interface to enable wake on lan";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      interfaces = {
        ${cfg.interface} = {
          wakeOnLan.enable = true;
        };
      };

      firewall = {
        allowedUDPPorts = [ 9 ];
      };
    };
  };
}
