{
  lib,
  config,
  hostList,
  ...
}:

let
  inherit (lib)
    mkForce
    mkIf
    ;

  cfg = config.modules.specialisation.gaming;
in
{
  options.modules.specialisation.gaming = {
    enable = lib.mkEnableOption "gaming boot specialisation";

    platform = lib.mkOption {
      type = lib.types.enum hostList;
      description = "host platform target tweaks";
    };
  };

  config = mkIf cfg.enable {
    specialisation."Gaming".configuration = lib.mkMerge [
      # ── Global settings ───────────────────────────────────────────────────────────
      {
        system.nixos.tags = [ "Gaming" ];

        modules.core = {
          display = {
            elyprismlauncher.enable = mkForce true;

            steam = {
              enable = mkForce true;
              features = {
                protonGE = mkForce true;
                gamemode = mkForce true;
                mangoHud = mkForce true;
              };
            };
          };

          services.tailscale.enable = mkForce true;
        };
      }

      # ── Desktop host (Full AMD) ───────────────────────────────────────────────────
      (mkIf (cfg.platform == "desktop") {
        modules.core.system = {
          kernel-cachyos = {
            enable = mkForce true;
            optimisationLevel = mkForce "zen4";
          };

          kernel-zen.enable = mkForce false;
          kernel-latest.enable = mkForce false;
        };
      })

      # ── Laptop host (iGPU + Nvidia) ───────────────────────────────────────────────
      (mkIf (cfg.platform == "laptop") {
        modules.core = {
          display = {
            moonlight.enable = mkForce true;
          };

          system = {
            kernel-cachyos = {
              enable = mkForce true;
              optimisationLevel = mkForce "v4";
            };

            kernel-zen.enable = mkForce false;
            kernel-latest.enable = mkForce false;
          };

          hardware = {
            msi = {
              enable = mkForce true;
              ec = {
                preset = mkForce "turbo";
                coolerBoost = mkForce true;
                webcamBlock = mkForce false;
                kbdBacklight = mkForce 3;
              };
            };

            nvidia-offload.enable = mkForce false;
            nvidia-sync.enable = mkForce true;
          };
        };
      })
    ];
  };
}
