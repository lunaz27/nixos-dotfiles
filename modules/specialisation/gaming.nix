{
  lib,
  config,
  pkgs,
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

        # Proton-GE performance boost
        boot.kernelModules = [ "ntsync" ];
        services.udev.extraRules = ''
          KERNEL=="ntsync", MODE="0666"
        '';

        # environment.systemPackages = with pkgs; [ mangohud ];

        # Steam + ProtonGE
        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-unwrapped"
          ];
        programs = {
          steam = {
            enable = true;

            gamescopeSession.enable = true;
            extraCompatPackages = with pkgs; [ proton-ge-bin ];
          };

          gamemode.enable = true;
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
            nvidia-hybrid.enable = lib.mkForce false;
            nvidia-sync.enable = lib.mkForce true;
          };
        };
      })
    ];
  };
}
