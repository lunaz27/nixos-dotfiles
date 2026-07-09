{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.bluetooth.enable = lib.mkEnableOption "bluetooth service";
  };

  config = lib.mkIf config.modules.core.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

}
