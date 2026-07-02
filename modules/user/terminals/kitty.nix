{
  flake.homeModules."kitty" =
    {
      config,
      ...
    }:

    let
      mkSymlink =
        pyFile:
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-dotfiles/config/kitty/${pyFile}";
    in
    {
      programs.kitty = {
        enable = true;

        font = {
          name = "JetBrainsMono Nerd Font";
          size = 11.0;
        };

        settings = {
          shell = "fish";

          confirm_os_window_close = "0";
          hide_window_decorations = "yes";
          cursor_shape = "beam";
          cursor_trail = "1";
          window_margin_width = "21.75";

          dynamic_background_opacity = "yes";
          background_opacity = "0.89";
        };

        keybindings = {
          "ctrl+c" = "copy_or_interrupt";
          "ctrl+f" =
            "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
          "page_up" = "scroll_page_up";
          "page_down" = "scroll_page_down";
          "ctrl+plus" = "change_font_size all +1";
          "ctrl+equal" = "change_font_size all +1";
          "ctrl+kp_add" = "change_font_size all +1";
          "ctrl+minus" = "change_font_size all -1";
          "ctrl+underscore" = "change_font_size all -1";
          "ctrl+kp_subtract" = "change_font_size all -1";
          "ctrl+0" = "change_font_size all 0";
          "ctrl+kp_0" = "change_font_size all 0";
        };
      };

      xdg.configFile = {
        "kitty/search.py".source = mkSymlink "search.py";
        "kitty/scroll_mark.py".source = mkSymlink "scroll_mark.py";
      };
    };
}
