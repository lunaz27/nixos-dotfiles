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
          # focus_pane_left = [
          #   "prefix+h"
          #   "ctrl+h"
          # ];
          # focus_pane_down = [
          #   "prefix+j"
          #   "ctrl+j"
          # ];
          # focus_pane_up = [
          #   "prefix+k"
          #   "ctrl+k"
          # ];
          # focus_pane_right = [
          #   "prefix+l"
          #   "ctrl+l"
          # ];
        };

        terminal = {
          default_shell = "fish";
          new_cwd = "follow";
          shell_mode = "login";
        };

        ui = {
          sidebar_min_width = 20;
          sidebar_width = 40;
          sidebar_max_width = 40;

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
