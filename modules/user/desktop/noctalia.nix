{
  lib,
  config,
  inputs,
  hostName,
  ...
}:

let
  outputMonitor =
    {
      desktop = "HDMI-A-1";
      laptop = "eDP-1";
    }
    .${hostName};

  cfg = config.modules.user.desktop.noctalia;
in
{
  options = {
    modules.user.desktop.noctalia = {
      enable = lib.mkEnableOption "noctalia-shell rewritten in C++/OpenCL";
    };
  };

  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;

      # settings = fromTOML (builtins.readFile ../dotfiles/config/noctalia/noctalia-config.toml);
      settings = {
        backdrop.enabled = true;

        bar = {
          order = [ "default" ];

          default = {
            margin_edge = 12;
            contact_shadow = true;

            start = [
              "launcher"
              "clock"
              "sysmon"
              "temp"
              "ram"
              "cpu"
              "media"
            ];
            center = [
              "workspaces"
            ];
            end = [
              "tray"
              "network"
              "bluetooth"
              "input_volume"
              "output_volume"
              "battery"
              "brightness"
              "privacy"
              "control-center"
            ];
          };
        };
        brightness = {
          minimum_brightness = 0.01;
        };

        calendar = {
          enabled = true;
          refresh_minutes = 240;

          account = {
            "personal_google" = {
              name = "sv_cal";
              type = "google";
            };
          };
        };

        desktop_widgets.enabled = false;

        dock = {
          enabled = true;

          background_opacity = 1.0;
          active_monitor_only = true;
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
            "Down"
          ];
          left = [
            "Ctrl+h"
            "Left"
          ];
          right = [
            "Ctrl+l"
            "Right"
          ];
          up = [
            "Ctrl+k"
            "Ctrl+p"
            "Up"
          ];
          validate = [
            "Ctrl+y"
            "Return"
          ];
        };

        location.address = "Ho Chi Minh City";

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;

          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };

          widget = {
            "lockscreen-login-box@${outputMonitor}" = {
              box_height = 196;
              box_width = if outputMonitor == "eDP-1" then 720 else 810;
              cx = 960;
              cy = 540;
              output = "${outputMonitor}";
              rotation = 0;
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.89;
                background_radius = 12;
                center_password_text = false;
                input_opacity = 1;
                input_radius = 6;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
              type = "login_box";
            };

            widget_order = [
              "lockscreen-login-box@${outputMonitor}"
            ];
          };
        };

        notification.layer = "overlay";

        osd.kinds.media = false;

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
          animation = {
            speed = 0.75;
          };

          avatar_path = ../../../public/images/pfp/youmu.png;
          corner_radius_scale = 1.75;
          font_family = "Work Sans SemiBold";
          password_style = "random";

          panel = {
            transparency_mode = "soft";
            open_near_click_control_center = true;
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
            builtin_ids = [
              "gtk3"
              "gtk4"
              "qt"
            ];
            community_ids = [ "zen-browser" ];
          };
        };

        wallpaper = {
          directory = ../../../public/images/wallpapers;
          default.path = ../../../public/images/wallpapers/sunsetLandscape.jpg;
          last.path = ../../../public/images/wallpapers/firewatch.png;

          transition_on_startup = true;
        };

        widget = {
          control-center = {
            custom_image = ../../../public/images/logos/nixos-flake.png;
          };
          cpu = {
            show_value = false;
          };

          launcher = {
            custom_image = ../../../public/images/icons/niri.svg;
          };

          media = {
            min_length = 0;
            title_scroll = "on_hover";
          };

          privacy = {
            inactive_color = "on_surface";
          };

          ram = {
            show_value = false;
          };

          sysmon = {
            show_value = false;
            stat = "disk_used";
          };

          temp = {
            show_value = false;
          };

          tray = {
            drawer = true;
            detached_panel = false;
          };

          workspaces = {
            capsule_radius = 8;
          };
        };
      };
    };
  };
}
