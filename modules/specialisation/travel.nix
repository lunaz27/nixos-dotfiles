{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkForce;

  cfg = config.modules.specialisation.travel;
in
{
  options = {
    modules.specialisation.travel = {
      enable = lib.mkEnableOption "battery saving boot specialisation";
    };
  };

  config = lib.mkIf cfg.enable {
    specialisation."Travel".configuration = {
      system.nixos.tags = [ "Travel" ];

      modules = {
        containers = {
          testbox.enable = mkForce false;
        };

        core = {
          hardware = {
            _battery-optimisation.enable = true;
            bluetooth.enable = mkForce false;
            msi = {
              enable = mkForce true;
              ec = {
                preset = mkForce "eco";
                coolerBoost = mkForce false;
                webcamBlock = mkForce true;
                kbdBacklight = mkForce 0;
              };
            };
            nvidia-disable.enable = mkForce true;
            nvidia-offload.enable = mkForce false;
            nvidia-sync.enable = mkForce false;
          };

          services = {
            mcontrolcenter.enable = mkForce false;
            openssh.enable = mkForce false;
            power = {
              enable = mkForce true;
              mode = mkForce "power-saver";
            };
            tailscale.enable = mkForce false;
          };
        };
      };
    };
  };
}
