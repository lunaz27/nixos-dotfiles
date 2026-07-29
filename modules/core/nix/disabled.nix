{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.nix.disabled;
in
{
  options = {
    modules.core.nix.disabled = {
      enable = lib.mkEnableOption "disable nano editor" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nano.enable = false;
  };
}
