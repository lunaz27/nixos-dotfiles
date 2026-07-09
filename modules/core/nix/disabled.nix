{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.disabled.enable = lib.mkEnableOption "disable nano editor";
  };

  config = lib.mkIf config.modules.core.disabled.enable {
    programs.nano.enable = false;
  };
}
