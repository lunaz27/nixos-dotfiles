{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.hardware.audio.enable = lib.mkEnableOption "pipewire + rtkit";
  };

  config = lib.mkIf config.modules.core.hardware.audio.enable {
    services.pipewire = {
      enable = true;

      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = false; # Use the `pw-jack` wrapper from `pipewire.jack` where necessary instead.
    };

    # Remove glitchy audio issue
    security.rtkit.enable = true;
  };
}
