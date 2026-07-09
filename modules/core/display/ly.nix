{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.ly.enable = lib.mkEnableOption "ly - tui login manager";
  };

  config = lib.mkIf config.modules.core.ly.enable {
    services.displayManager = {
      ly = {
        enable = true;
        x11Support = false;

        # NOTE: Docs: https://github.com/fairyglade/ly/blob/master/res/config.ini
        settings = {
          animation = "colormix";

          asterisk = "*";
          clear_password = true;

          vi_mode = true;
          vi_default_mode = "normal";

          session_log = null;
          show_tty = true;

          shell = false;
          xinitrc = null;

          brightness_up_key = null;
          brightness_down_key = null;
          show_password_key = "F5";
        };
      };

      sessionPackages = [ pkgs.niri ];
    };
  };
}
