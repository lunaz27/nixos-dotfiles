{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.keyboard.enable = lib.mkEnableOption "wireless keyboard fix";
  };

  config = lib.mkIf config.modules.core.keyboard.enable {
    boot.kernelParams = [ "hid_apple.fnmode=2" ];
  };
}
