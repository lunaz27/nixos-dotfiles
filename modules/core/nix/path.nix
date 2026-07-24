{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.modules.core.nix.path;
in
{
  options = {
    modules.core.nix.path = {
      enable =
        lib.mkEnableOption "force legacy channel to be off and follow packages on flake inputs"
        // {
          default = true;
        };
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
      ];

      channel.enable = false;
    };
  };
}
