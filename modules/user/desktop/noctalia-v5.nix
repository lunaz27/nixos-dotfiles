{
  flake.homeModules."noctalia-v5" =
    {
      inputs,
      ...
    }:

    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        # settings = fromTOML (builtins.readFile ../../../config/noctalia/noctalia-config.toml);

        settings = {
          backdrop.enabled = true;

          bar = {
            "default" = {
              contact_shadow = true;

              capsule_group = [
                {
                  fill = "surface_variant";

                  members = [
                    "sysmon"
                    "temp"
                    "ram"
                    "cpu"
                  ];
                  id = "g1";
                  start = [
                    "launcher"
                    "clock"
                    "group:g1"
                    "media"
                  ];
                  opacity = 0;
                  padding = 6;
                }
              ];
              center = [ "workspaces" ];
              end = [
                "tray"
                "network"
                "bluetooth"
                "input_volume"
                "output_volume"
                "battery"
                "brightness"
                "control-center"
              ];
            };
          };

          desktop_widgets.enabled = false;

          dock = {
            enabled = true;

            cross_axis_padding = 6;
            icon_size = 35;
            item_spacing = 5;
            launcher_icon = "list-search";
            launcher_position = "start";
            main_axis_padding = 12;
            margin_edge = 12;
          };

          keybinds = {
            down = [
              "Ctrl+j"
              "Ctrl+n"
            ];
            left = [ "Ctrl+h" ];
            right = [ "Ctrl+l" ];
            up = [
              "Ctrl+k"
              "Ctrl+p"
            ];
            validate = [
              "Ctrl+y"
              "Return"
            ];
          };

          location.address = "Ho Chi Minh City";

          lockscreen_widgets = {
            schema_version = 2;

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = {
              "lockscreen-login-box@eDP-1" = {
                type = "login_box";
                box_height = 0;
                box_width = 0;
                cx = 960;
                cy = 540;
                output = "eDP-1";
                rotation = 0;

                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.88;
                  background_radius = 12;
                  input_opacity = 1;
                  input_radius = 6;
                  show_login_button = true;
                };

              };
            };

            widget_order = [ "lockscreen-login-box@eDP-1" ];

          };
          plugins = {
            enabled = [ ];
            source = [
              {
                kind = "git";
                location = "https://github.com/noctalia-dev/community-plugins";
                name = "community";
              }
              {
                kind = "git";
                location = "https://github.com/noctalia-dev/official-plugins";
                name = "official";
              }
            ];
          };

          shell = {
            avatar_path = ../../../images/pfp/youmu.png;
            corner_radius_scale = 1.75;
            font_family = "Work Sans SemiBold";

            panel = {
              open_near_click_control_center = true;
              session_placement = "centered";
            };

            polkit_agent = true;

            screen_corners.enabled = true;
            screen_time_enabled = true;

            session = {
              actions = [
                {
                  action = "lock";
                  enabled = true;
                  shortcut = "1";
                  variant = "primary";
                }
                {
                  action = "lock_and_suspend";
                  enabled = true;
                  shortcut = "2";
                  variant = "primary";
                }
                {
                  action = "logout";
                  enabled = true;
                  shortcut = "3";
                  variant = "secondary";
                }
                {
                  action = "reboot";
                  enabled = true;
                  shortcut = "4";
                  variant = "destructive";
                }
                {
                  action = "shutdown";
                  enabled = true;
                  shortcut = "5";
                  variant = "destructive";
                }
              ];
            };

            settings_show_advanced = true;
          };

          theme = {
            builtin = "Catppuccin";
            source = "builtin";
            templates = {
              builtin_ids = [ "niri" ];
              community_ids = [ "zen-browser" ];
            };
          };

          wallpaper = {
            directory = ../../../images/wallpapers;

            default.path = ../../../images/wallpapers/firewatch.png;
            last.path = ../../../images/wallpapers/sunsetLandscape.jpg;
          };

          widget = {
            control-center = {
              custom_image = ../../../images/logos/nixos-flake.png;
            };
            cpu = {
              show_label = false;
            };

            launcher = {
              custom_image = ../../../images/icons/niri.svg;
            };

            media = {
              min_length = 0;
              title_scroll = "on_hover";
            };

            network = {
              show_label = false;
            };

            ram = {
              show_label = false;
            };

            sysmon = {
              show_label = false;
              stat = "disk_pct";
            };

            temp = {
              show_label = false;
            };

            tray = {
              detached_panel = true;
              drawer = true;
            };

            workspaces = {
              capsule_radius = 8;
            };
          };
        };
      };
    };
}
