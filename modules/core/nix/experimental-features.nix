{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.experimental-features.enable = lib.mkEnableOption "enable flakes and nix nix-command";
  };

  config = lib.mkIf config.modules.core.experimental-features.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
