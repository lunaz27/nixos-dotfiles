{
  lib,
  config,
  ...
}:

{
  options = {
    modules.specialisation.travel.enable = lib.mkEnableOption "battery saving boot specialisation";
  };

  config = lib.mkIf config.modules.specialisation.travel.enable {
    specialisation."Travel".configuration = {
      system.nixos.tags = [ "Travel" ];

      modules.core = {
        hardware = {
          msi = {
            enable = lib.mkForce true;
            ec.preset = lib.mkForce "eco";
          };
          nvidia-disable.enable = lib.mkForce true;
          nvidia-offload.enable = lib.mkForce false;
          nvidia-sync.enable = lib.mkForce false;
        };

        services = {
          mcontrolcenter.enable = lib.mkForce false;
          power = {
            enable = lib.mkForce true;
            mode = lib.mkForce "power-saver";
          };
        };
      };
    };
  };
}
