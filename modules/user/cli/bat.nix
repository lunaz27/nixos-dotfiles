{
  lib,
  config,
  ...
}:

{
  options = {
    modules.user.cli.bat.enable = lib.mkEnableOption "bat - fancier cat";
  };

  config = lib.mkIf config.modules.apps.cli.bat.enable {
    programs.bat.enable = true;
  };
}
