{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.core.services.keyd;
in
{
  options = {
    modules.core.services.keyd = {
      enable = lib.mkEnableOption "keyd configuration" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;

      keyboards = {
        default = {
          ids = [ "*" ];

          settings = {
            main = {
              capslock = "overload(nav, esc)";
            };

            nav = {
              h = "left";
              j = "down";
              k = "up";
              l = "right";
              tab = "macro(space space)";
            };
          };
        };
      };
    };
  };
}
