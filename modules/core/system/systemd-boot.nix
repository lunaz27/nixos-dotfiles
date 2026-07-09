{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.systemd-boot.enable = lib.mkEnableOption "systemd boot loader";
  };

  config = lib.mkIf config.modules.core.systemd-boot.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
