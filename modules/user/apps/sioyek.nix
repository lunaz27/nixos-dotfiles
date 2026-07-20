{
  lib,
  config,
  ...
}:

{
  options = {
    modules.user.apps.sioyek.enable =
      lib.mkEnableOption "sioyek - a keyboard-driven pdf viewer designed for technical papers";
  };

  config = lib.mkIf config.modules.user.apps.sioyek.enable {
    programs.sioyek = {
      enable = true;

      bindings = {
        "next_page" = [
          "J"
          "<space>"
        ];
        "previous_page" = [
          "K"
          "<S-space>"
        ];

        "screen_down" = [
          "<C-d>"
        ];
        "screen_up" = [
          "<C-u>"
        ];

        "toggle_custom_color" = "<C-r>";
        "fit_to_page_width" = "w";
        "fit_to_page_width_smart" = "e";
      };
      config.startup_commands = [ ];
    };
  };
}
