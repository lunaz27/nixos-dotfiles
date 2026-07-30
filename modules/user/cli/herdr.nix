{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.user.cli.herdr;
in
{
  options = {
    modules.user.cli.herdr = {
      enable = lib.mkEnableOption "modern tmux alternative";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.herdr = {
      enable = true;

      settings = {
        onboarding = false;

        theme = {
          name = "catppuccin";
        };

        keys = {
        };

        terminal = {
          default_shell = "fish";
          new_cwd = "follow";
          shell_mode = "auto";
        };

        ui = {
          sidebar_width = 75;

          sidebar.agents = {
            rows = [ ];
          };

          toast = {
            delivery = "herdr";
            herdr.position = "top-right";
          };
        };

        experimental = {
          kitty_graphics = true;
        };
      };
    };
  };
}
