{
  lib,
  config,
  inputs,
  ...
}:

{
  options = {
    modules.core.nix.niri-cachix.enable = lib.mkEnableOption "niri binary from cachix";
  };

  config = lib.mkIf config.modules.core.nix.niri-cachix.enable {
    nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
    programs.niri.enable = true;

    nix.settings = {
      substituters = [
        "https://niri.cachix.org"
      ];

      trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };
}
