{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.user.cli.superfile;
in
{
  options = {
    modules.user.cli.superfile = {
      enable = lib.mkEnableOption "modern terminal file manager";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.superfile = {
      enable = true;
      firstUseCheck = false;

      pinnedFolders = [
        {
          name = "Nix Store";
          location = "/nix/store";
        }
        {
          name = "NixOS Dotfiles";
          location = "${config.home.homeDirectory}/nixos-dotfiles";
        }
      ];
      hotkeys = {
        #-- Basic Actions
        confirm = [
          "enter"
          "right"
          "l"
        ];
        quit = [
          "ctrl+c"
          "Q"
        ];
        cd_quit = [
          "Q"
          ""
        ];

        #-- Navigation
        list_up = [
          "k"
          "up"
        ];
        list_down = [
          "j"
          "down"
        ];
        page_up = [
          "ctrl+u"
          "pgup"
        ];
        page_down = [
          "ctrl+d"
          "pgdown"
        ];

        #-- File Panel Controls;
        create_new_file_panel = [
          "n"
          ""
        ];
        close_file_panel = [
          "q"
          ""
        ];
        next_file_panel = [
          "tab"
          ""
        ];
        previous_file_panel = [
          "shift+tab"
          ""
        ];
        split_file_panel = [
          "N"
          ""
        ];
        toggle_file_preview_panel = [
          "f"
          ""
        ];
        open_sort_options_menu = [
          "o"
          ""
        ];
        toggle_reverse_sort = [
          "R"
          ""
        ];

        #-- Focus Manipulation
        focus_on_process_bar = [
          "ctrl+p"
          ""
        ];
        focus_on_sidebar = [
          "ctrl+s"
          ""
        ];
        focus_on_metadata = [
          "ctrl+m"
          ""
        ];

        #-- File/Dir Creation/Renaming
        file_panel_item_create = [
          "a"
          ""
        ];
        file_panel_item_rename = [
          "r"
          ""
        ];

        #-- Main File Operations
        copy_items = [
          "y"
          ""
        ];
        cut_items = [
          "x"
          ""
        ];
        paste_items = [
          "p"
          ""
        ];
        delete_items = [
          "d"
          ""
        ];
        permanently_delete_items = [
          "D"
          ""
        ];

        #-- Archive Manipulation
        extract_file = [
          "ctrl+e"
          ""
        ];
        compress_file = [
          "ctrl+a"
          ""
        ];

        #-- Editor Actions
        open_file_with_editor = [
          "e"
          ""
        ];
        open_current_directory_with_editor = [
          "E"
          ""
        ];

        #-- Other Actions
        pinned_directory = [
          "P"
          ""
        ];
        toggle_dot_file = [
          "."
          ""
        ];
        change_panel_mode = [
          "v"
          ""
        ];
        open_help_menu = [
          "?"
          ""
        ];
        open_spf_prompt = [
          ">"
          ""
        ];
        open_command_line = [
          ":"
          ""
        ];
        open_zoxide = [
          "z"
          ""
        ];
        copy_path = [
          "Y"
          ""
        ];
        copy_present_working_directory = [
          "c"
          ""
        ];
        toggle_footer = [
          "ctrl+f"
          ""
        ];

        ###############################################################################
        #                                Typing hotkeys                               #
        ###############################################################################

        confirm_typing = [
          "enter"
          ""
        ];
        cancel_typing = [
          "esc"
          ""
        ];

        ###############################################################################
        #                            Mode-Specific Hotkeys                            #
        ###############################################################################

        #-- Normal Mode Actions
        parent_directory = [
          "h"
          "left"
          "backspace"
        ];
        search_bar = [
          "/"
          ""
        ];

        #-- Selection Mode Actions
        file_panel_select_mode_items_select_down = [
          "J"
          ""
        ];
        file_panel_select_mode_items_select_up = [
          "K"
          ""
        ];
        file_panel_select_all_items = [
          "A"
          ""
        ];
      };
      settings = {
        theme = "catppuccin-mocha";
        editor = "nvim";
        dir_editor = "nvim";
        auto_check_update = false;
        cd_on_quit = true;
        ignore_missing_fields = true;

        default_directory = ".";
        nerdfont = true;
        show_image_preview = true;
        code_previewer = "bat";
        file_panel_extra_columns = 2;
        zoxide_support = true;
        transparent_background = true;
      };
    };
  };
}
