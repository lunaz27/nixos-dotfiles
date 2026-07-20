{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.nix.niri-cachix.enable = lib.mkEnableOption "niri binary from cachix";
  };

  config = lib.mkIf config.modules.core.nix.niri-cachix.enable {
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
