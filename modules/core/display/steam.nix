{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.core.display.steam;
in
{
  options = {
    modules.core.display.steam = {
      enable = lib.mkEnableOption "enables steam";

      features = {
        protonGE = lib.mkEnableOption "enables protonGE";
        gamemode = lib.mkEnableOption "enables gamemoderun command";
        mangoHud = lib.mkEnableOption "enables in-game stats monitoring";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # ── Base Steam ────────────────────────────────────────────────────────────────
      {
        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-unwrapped"
          ];

        programs.steam = {
          enable = true;
          gamescopeSession.enable = true;
        };
      }

      # ── Proton-GE + NTSync ────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.protonGE {
        boot.kernelModules = [ "ntsync" ];
        services.udev.extraRules = ''
          KERNEL=="ntsync", MODE="0666"
        '';
        programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];
      })

      # ── Gamemode ──────────────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.gamemode {
        programs.gamemode.enable = true;
      })

      # ── MangoHud ──────────────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.mangoHud {
        environment.systemPackages = with pkgs; [ mangohud ];
      })
    ]
  );
}
