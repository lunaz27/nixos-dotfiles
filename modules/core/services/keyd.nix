{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.keyd.enable = lib.mkEnableOption "keyd configuration";
  };

  config = lib.mkIf config.modules.core.keyd.enable {
    services.keyd = {
      enable = true;

      keyboards = {
        default = {
          ids = [ "*" ];

          settings = {
            main = {
              capslock = "escape";
            };
          };
        };
      };
    };
  };
}
