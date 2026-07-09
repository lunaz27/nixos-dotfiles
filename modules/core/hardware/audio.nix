{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.audio.enable = lib.mkEnableOption "pipewire + rtkit";
  };

  config = lib.mkIf config.modules.core.audio.enable {
    # Enable sound (pipewire)
    services.pipewire = {
      enable = true;

      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    # Remove glitchy audio issue
    security.rtkit.enable = true;
  };
}
