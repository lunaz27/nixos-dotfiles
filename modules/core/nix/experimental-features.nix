{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.nix.experimental-features.enable =
      lib.mkEnableOption "enables flakes and nix nix-command";
  };

  config = lib.mkIf config.modules.core.nix.experimental-features.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      # "pipe-operators"
    ];
  };
}
