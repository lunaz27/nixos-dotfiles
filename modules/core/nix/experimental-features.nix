{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.nix.experimental-features;
in
{
  options = {
    modules.core.nix.experimental-features = {
      enable = lib.mkEnableOption "enables flakes and nix nix-command" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      # "pipe-operators"
    ];
  };
}
