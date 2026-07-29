{
  lib,
  config,
  userName,
  ...
}:

let
  inherit (lib) mkForce;

  cfg = config.modules.specialisation.server;
in
{
  options = {
    modules.specialisation.server = {
      enable = lib.mkEnableOption "dedicated specialisation for running servers (e.g., minecraft-server)";
    };
  };

  config = lib.mkIf cfg.enable {
    specialisation."Server" = {
      configuration = {
        system.nixos.tags = [ "Server" ];

        # Remove home manager bloat
        home-manager.users.${userName} = { };

        modules.core = {
          hardware = {
            msi.ec = {
              webcamBlock = mkForce true;
              kbdBacklight = mkForce 0;
            };

            nvidia-offload.enable = mkForce false;
            nvidia-disable.enable = mkForce true;
          };

          services = {
            niri-autologin.enable = mkForce false;
            tty-autologin.enable = mkForce true;
            logind.ignoreLidClosing = mkForce true;
            minecraft-server.enable = mkForce true;
            tailscale.enable = mkForce true;
          };

          system = {
            kernel-zen.enable = mkForce false;
            kernel-cachyos = {
              enable = mkForce true;
              optimisationLevel = mkForce "v4";
            };
          };
        };
      };
    };
  };
}
