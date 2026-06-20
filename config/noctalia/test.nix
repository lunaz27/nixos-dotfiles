{
  backdrop = {
    enabled = true;
  };
  bar = {
    default = {
      capsule_group = [
        {
          fill = "surface_variant";
          id = "g1";
          members = [
            "sysmon"
            "temp"
            "ram"
            "cpu"
          ];
          opacity = 0;
          padding = 6;
        }
      ];
      center = [ "workspaces" ];
      contact_shadow = true;
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
      start = [
        "launcher"
        "clock"
        "sysmon"
        "temp"
        "ram"
        "cpu"
        "media"
      ];
    };
  };
  brightness = {
    minimum_brightness = 0.01;
  };
  calendar = {
    account = {
      personal_google = {
        name = "sv_cal";
        type = "google";
      };
    };
    enabled = true;
  };
  desktop_widgets = {
    enabled = false;
    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };
    schema_version = 2;
    widget = { };
    widget_order = [ ];
  };
  dock = {
    cross_axis_padding = 6;
    enabled = true;
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
  location = {
    address = "Ho Chi Minh City";
  };
  lockscreen_widgets = {
    enabled = false;
    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };
    schema_version = 2;
    widget = {
      "lockscreen-login-box@HDMI-A-1" = {
        box_height = 0;
        box_width = 0;
        cx = 720;
        cy = 777;
        output = "HDMI-A-1";
        rotation = 0;
        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12;
          input_opacity = 1;
          input_radius = 6;
          show_login_button = true;
        };
        type = "login_box";
      };
      "lockscreen-login-box@eDP-1" = {
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
        type = "login_box";
      };
    };
    widget_order = [
      "lockscreen-login-box@HDMI-A-1"
      "lockscreen-login-box@eDP-1"
    ];
  };
  nightlight = {
    temperature_day = 10000;
  };
  osd = {
    kinds = {
      media = false;
    };
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
    animation = {
      speed = 0.75;
    };
    avatar_path = "/home/suwapotta/nixos-dotfiles/images/pfp/youmu.png";
    corner_radius_scale = 1.75;
    font_family = "Work Sans SemiBold";
    panel = {
      open_near_click_control_center = true;
      session_placement = "centered";
    };
    polkit_agent = true;
    screen_corners = {
      enabled = true;
    };
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
    community_palette = "Oxocarbon";
    mode = "dark";
    source = "builtin";
    templates = {
      builtin_ids = [ "niri" ];
      community_ids = [ "zen-browser" ];
    };
    wallpaper_scheme = "m3-content";
  };
  wallpaper = {
    default = {
      path = "/home/suwapotta/nixos-dotfiles/images/wallpapers/oceanSunsetWaveSequence.jpg";
    };
    directory = "/home/suwapotta/nixos-dotfiles/images/wallpapers";
    last = {
      path = "/home/suwapotta/nixos-dotfiles/images/wallpapers/oceanSunsetWaveSequence.jpg";
    };
    monitors = {
      eDP-1 = {
        path = "/home/suwapotta/nixos-dotfiles/images/wallpapers/oceanSunsetWaveSequence.jpg";
      };
    };
    transition_on_startup = true;
  };
  widget = {
    active_window = {
      display = "icon_only";
      title_scroll = "on_hover";
    };
    cat = {
      type = "noctalia/bongocat:cat";
    };
    control-center = {
      custom_image = "/home/suwapotta/nixos-dotfiles/images/logos/nixos-flake.png";
    };
    cpu = {
      show_label = false;
    };
    launcher = {
      custom_image = "/home/suwapotta/nixos-dotfiles/images/icons/niri.svg";
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
}
