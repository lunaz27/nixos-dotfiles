{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.users;
in
{
  options = {
    modules.core.users = {
      enable = lib.mkEnableOption "users declaration";
      remoteBuilder = lib.mkEnableOption "dedicated user for remote compilation";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users = lib.mkMerge [
        # ── Global ────────────────────────────────────────────────────────────────────
        {
          "suwapotta" = {
            isNormalUser = true;
            extraGroups = [
              "wheel"
              "networkmanager"
            ];
          };
        }

        # ── Remote Builder ────────────────────────────────────────────────────────────
        (lib.mkIf cfg.remoteBuilder {
          "nix-builder" = {
            # TODO: https://nix.dev/tutorials/nixos/distributed-builds-setup.html#alternatives
          };
        })
      ];
    };
  };
}
