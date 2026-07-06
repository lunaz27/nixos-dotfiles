{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.ryzen.enable = lib.mkEnableOption "amd cpu";
  };

  config = lib.mkIf config.modules.core.ryzen.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      # extraPackages = with pkgs; [
      # ];
    };
  };
}
