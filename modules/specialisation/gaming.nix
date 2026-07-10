{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.specialisation.gaming;
in
{
  options.modules.specialisation.gaming = {
    enable = lib.mkEnableOption "gaming boot specialisation";

    platform = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "laptop"
      ];
      description = "host platform target tweaks";
    };
  };

  config = lib.mkIf cfg.enable {
    specialisation."Gaming".configuration = lib.mkMerge [
      # ── Global settings ───────────────────────────────────────────────────────────
      {
        system.nixos.tags = [ "Gaming" ];

        modules.core.display.steam = {
          enable = lib.mkForce true;
          features = {
            protonGE = lib.mkForce true;
            gamemode = lib.mkForce true;
            mangoHud = lib.mkForce true;
          };
        };
      }

      # ── Desktop host (Full AMD) ───────────────────────────────────────────────────
      (lib.mkIf (cfg.platform == "desktop") {
        modules.core.system = {
          kernel-cachyos = {
            enable = lib.mkForce true;
            optimisationLevel = lib.mkForce "zen4";
          };

          kernel-zen.enable = lib.mkForce false;
          kernel-latest.enable = lib.mkForce false;
        };
      })

      # ── Laptop host (iGPU + Nvidia) ───────────────────────────────────────────────
      (lib.mkIf (cfg.platform == "laptop") {
        modules.core = {
          system = {
            kernel-cachyos = {
              enable = lib.mkForce true;
              optimisationLevel = lib.mkForce "v4";
            };

            kernel-zen.enable = lib.mkForce false;
            kernel-latest.enable = lib.mkForce false;
          };

          hardware = {
            nvidia-offload.enable = lib.mkForce false;
            nvidia-sync.enable = lib.mkForce true;
          };
        };
      })
    ];
  };
}
