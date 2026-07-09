{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.polkit.enable = lib.mkEnableOption "soteria polkit";
  };

  config = lib.mkIf config.modules.core.polkit.enable {
    security.soteria.enable = true;
  };
}
