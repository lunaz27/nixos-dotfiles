{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.nh.enable = lib.mkEnableOption "nh - nix cli helper";
  };

  config = lib.mkIf config.modules.core.nh.enable {
    programs.nh = {
      enable = true;

      clean = {
        enable = true;

        dates = "weekly";
        extraArgs = "--keep 3";
      };
    };
  };
}
