{
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkIf
    mkForce
    ;

  cfg = config.modules.specialisation.remote-play;
in
{
  options.modules.specialisation.remote-play = {
    enable = lib.mkEnableOption "remote access through sunshine + moonlight specialisation";
  };

  config = mkIf cfg.enable {
    specialisation."Remote-Play".configuration = {
      system.nixos.tags = [ "Remote-Play" ];

      modules.core = {
        display = {
          elyprismlauncher.enable = mkForce true;
          ly.enable = mkForce false;
          # steam = {
          #   enable = mkForce true;
          #   features = {
          #     protonGE = mkForce true;
          #     gamemode = mkForce true;
          #     mangoHud = mkForce true;
          #   };
          # };
        };

        services = {
          niri-autologin.enable = mkForce true;
          sunshine.enable = mkForce true;
          tailscale.enable = mkForce true;
        };

        system = {
          kernel-cachyos = {
            enable = mkForce true;
            optimisationLevel = mkForce "zen4";
          };

          kernel-zen.enable = mkForce false;
        };
      };
    };
  };
}
