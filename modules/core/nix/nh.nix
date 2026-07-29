{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.nix.nh;
in
{
  options = {
    modules.core.nix.nh = {
      enable = lib.mkEnableOption "nh - nix cli helper" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = toString ../../../../nixos-dotfiles;

      clean = {
        enable = true;

        dates = "weekly";
        extraArgs = "--keep 3";
      };
    };
  };
}
