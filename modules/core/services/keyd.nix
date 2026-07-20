{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.services.keyd.enable = lib.mkEnableOption "keyd configuration";
  };

  config = lib.mkIf config.modules.core.services.keyd.enable {
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
            };
          };
        };
      };
    };
  };
}
