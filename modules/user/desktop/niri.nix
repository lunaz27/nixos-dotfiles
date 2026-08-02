{
  lib,
  config,
  pkgs,
  hostName,
  ...
}:

let
  cfg = config.modules.user.desktop.niri;
in
{
  options.modules.user.desktop.niri = {
    enable = lib.mkEnableOption "scrollable-tiling wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.niri = {
      enable = true;
      xwaylandSatellitePackage = pkgs.xwayland-satellite;
      portalPackage = pkgs.xdg-desktop-portal-gnome;

      settings = {
        # ── Animation ─────────────────────────────────────────────────────────────────
        animations = {
          on = { };
          slowdown = 1.5;

          window-open = {
            duration-ms = 260;
            curve = [
              "cubic-bezier"
              0.22
              1.0
              0.36
              1.0
            ];
            custom-shader = /* glsl */ ''
              vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_clamped_progress;
                float slide_px = (1.0 - p) * 60.0;
                float slide_geo = slide_px / max(size_geo.x, 1.0);
                float scale = 0.985 + 0.015 * p;

                vec2 uv = coords_geo.xy;
                uv -= vec2(0.5, 0.5);
                uv /= scale;
                uv += vec2(0.5, 0.5);
                uv.y -= slide_geo;

                vec3 coords_tex = niri_geo_to_tex * vec3(uv, 1.0);
                vec4 color = texture2D(niri_tex, coords_tex.st);

                color *= p;
                return color;
              }
            '';
          };

          window-close = {
            duration-ms = 180;
            curve = [
              "cubic-bezier"
              0.32
              0.0
              0.67
              0.0
            ];
            custom-shader = /* glsl */ ''
              vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                float p = niri_clamped_progress;
                float inv = 1.0 - p;
                float slide_px = p * 40.0;
                float slide_geo = slide_px / max(size_geo.x, 1.0);
                float scale = 1.0 - 0.012 * p;

                vec2 uv = coords_geo.xy;
                uv -= vec2(0.5, 0.5);
                uv /= scale;
                uv += vec2(0.5, 0.5);
                uv.y -= slide_geo;

                vec3 coords_tex = niri_geo_to_tex * vec3(uv, 1.0);
                vec4 color = texture2D(niri_tex, coords_tex.st);

                color *= inv;
                return color;
              }
            '';
          };

          window-resize = {
            spring._props = {
              damping-ratio = 1.0;
              stiffness = 720;
              epsilon = 0.0001;
            };
            custom-shader = /* glsl */ ''
              vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
                vec3 coords_tex_next = niri_geo_to_tex_next * coords_curr_geo;
                vec4 color = texture2D(niri_tex_next, coords_tex_next.st);
                vec2 uv = coords_curr_geo.xy;

                float edge = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
                float vignette = smoothstep(0.0, 0.06, edge);

                color.rgb *= mix(0.985, 1.0, vignette);
                return color;
              }
            '';
          };

          workspace-switch.spring._props = {
            damping-ratio = 1.0;
            stiffness = 760;
            epsilon = 0.0001;
          };
          horizontal-view-movement.spring._props = {
            damping-ratio = 1.0;
            stiffness = 640;
            epsilon = 0.0001;
          };
          window-movement.spring._props = {
            damping-ratio = 1.0;
            stiffness = 700;
            epsilon = 0.0001;
          };
          config-notification-open-close.spring._props = {
            damping-ratio = 1.0;
            stiffness = 820;
            epsilon = 0.001;
          };
          exit-confirmation-open-close.spring._props = {
            damping-ratio = 1.0;
            stiffness = 560;
            epsilon = 0.01;
          };
          screenshot-ui-open = {
            duration-ms = 220;
            curve = [
              "cubic-bezier"
              0.22
              1.0
              0.36
              1.0
            ];
          };
          overview-open-close.spring._props = {
            damping-ratio = 1.0;
            stiffness = 620;
            epsilon = 0.0001;
          };
          recent-windows-close.spring._props = {
            damping-ratio = 1.0;
            stiffness = 680;
            epsilon = 0.001;
          };
        };

        # ── Input ─────────────────────────────────────────────────────────────────────
        input = {
          keyboard = {
            xkb.layout = "en";
            track-layout = "window";
            repeat-delay = 250;
            repeat-rate = 35;
          };

          mouse = {
            accel-profile = "flat";
          };

          warp-mouse-to-focus._props.mode = "center-xy";
          focus-follows-mouse._props.max-scroll-amount = "0%";
          workspace-auto-back-and-forth = { };
        }
        // lib.optionalAttrs (hostName == "laptop") {
          touchpad = {
            tap = { };
            dwt = { };
            dwtp = { };
            natural-scroll = { };
          };
        };

        # ── Layout ────────────────────────────────────────────────────────────────────
        layout = {
          gaps = 10;
          background-color = "transparent";
          center-focused-column = "never";
          always-center-single-column = { };
          default-column-display = "normal";

          preset-column-widths._children = [
            { proportion = 1 / 3.0; }
            { proportion = 1 / 2.0; }
            { proportion = 2 / 3.0; }
          ];

          default-column-width.proportion = 0.5;
          focus-ring = {
            off = { };

            active-color = "#cba6f7";
            inactive-color = "#1e1e2e";
            urgent-color = "#f38ba8";
          };

          border = {
            active-color = "#cba6f7";
            inactive-color = "#1e1e2e";
            urgent-color = "#f38ba8";
          };

          shadow = {
            color = "#11111b70";
          };

          tab-indicator = {
            active-color = "#cba6f7";
            inactive-color = "#6b02e9";
            urgent-color = "#f38ba8";
          };

          insert-hint = {
            color = "#cba6f780";
          };
        };

        # ── Blur ──────────────────────────────────────────────────────────────────────
        blur = {
          passes = 3;
          offset = 6.0;
          noise = 0.03;
          saturation = 1.5;
        };

        # ── Misc/ Switch events / Debug ───────────────────────────────────────────────
        # switch-events = {
        #   lid-close.spawn-sh = "noctalia msg session lock-and-suspend";
        # };
        prefer-no-csd = { };

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        cursor = {
          hide-when-typing = { };
          hide-after-inactive-ms = 5000;
        };

        overview.zoom = 0.5;
        hotkey-overlay.skip-at-startup = { };

        _children =
          # ── Outputs ───────────────────────────────────────────────────────────────────
          lib.optionals (hostName == "desktop") [
            {
              output = {
                _args = [ "HDMI-A-1" ];
                mode = "1920x1080@75.000";
                variable-refresh-rate = { };
                scale = 1.0;
                hot-corners.bottom-right = { };
              };
            }
          ]
          ++ lib.optionals (hostName == "laptop") [
            {
              output = {
                _args = [ "eDP-1" ];
                mode = "1920x1080@60.001";
                scale = 1.0;
                hot-corners.bottom-right = { };
              };
            }
          ]
          ++ [
            # ── Layer Rules ───────────────────────────────────────────────────────────────
            {
              layer-rule = {
                match._props.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";

                opacity = 0.89;
                background-effect = {
                  blur = true;
                  xray = false;
                };
              };
            }

            # {
            #   layer-rule = {
            #     match._props.namespace = "^noctalia-(bar-[^\"]+|attached-panel)$";
            #
            #     opacity = 0.89;
            #     background-effect = {
            #       blur = false;
            #       xray = false;
            #     };
            #   };
            # }

            # Blur overview wallpaper
            {
              layer-rule = {
                match._props.namespace = "^noctalia-backdrop*";
                place-within-backdrop = true;
              };
            }

            # ── Window Rules ──────────────────────────────────────────────────────────────
            {
              window-rule = {
                match._props = {
                  app-id = "zen-beta$";
                  title = "^Picture-in-Picture$";
                };

                open-floating = true;
                default-column-width.fixed = 480;
                default-window-height.fixed = 270;
                default-floating-position._props = {
                  x = 0;
                  y = 0;
                  relative-to = "bottom-right";
                };
              };
            }

            {
              window-rule = {
                match._props.app-id = "zen-beta$";
                open-maximized = true;
              };
            }

            {
              window-rule._children = [
                { match._props.app-id = "^kitty$"; }
                { match._props.app-id = "^anki$"; }
                { match._props.app-id = "^org\\.gnome\\.Nautilus$"; }
                { match._props.app-id = "^xdg-desktop-portal-gtk$"; }

                { opacity = 0.89; }
                { draw-border-with-background = false; }
                { clip-to-geometry = true; }
                {
                  background-effect = {
                    blur = true;
                    xray = false;
                  };
                }
              ];
            }

            {
              window-rule._children = [
                { match._props.app-id = "^floating.*"; }
                { match._props.is-floating = true; }

                {
                  background-effect = {
                    blur = true;
                    xray = false;
                  };
                }
              ];
            }

            {
              window-rule = {
                match._props.app-id = "^floating.*";

                open-floating = true;
                draw-border-with-background = false;
                default-window-height.proportion = 0.90;
                default-column-width.proportion = 0.75;
              };
            }

            # Neovim modes
            {
              window-rule = {
                match._props.title = "^nvim-N";

                border = {
                  active-color = "#89b4fb";
                  inactive-color = "#1e1e2e";
                  urgent-color = "#f38ba9";
                };
              };
            }
            {
              window-rule = {
                match._props.title = "^nvim-[IT]";

                border = {
                  active-color = "#a6e3a2";
                  inactive-color = "#1e1e2e";
                  urgent-color = "#f38ba9";
                };
              };
            }

            {
              window-rule = {
                match._props.title = "^nvim-V";

                border = {
                  active-color = "#cba6f8";
                  inactive-color = "#1e1e2e";
                  urgent-color = "#f38ba9";
                };
              };
            }

            {
              window-rule = {
                match._props.title = "^nvim-C";
                border = {
                  active-color = "#fab388";
                  inactive-color = "#1e1e2e";
                  urgent-color = "#f38ba9";
                };
              };
            }

            {
              window-rule = {
                match._props.title = "^nvim-R";
                border = {
                  active-color = "#f38ba8";
                  inactive-color = "#1e1e2e";
                  urgent-color = "#f38ba9";
                };
              };
            }

            # Noctalia
            {
              window-rule = {
                geometry-corner-radius = 20;
                clip-to-geometry = true;
              };
            }
            {
              window-rule = {
                match._props.app-id = "dev.noctalia.Noctalia.Settings";

                open-floating = true;
                default-column-width.fixed = 1080;
                default-window-height.fixed = 920;
              };
            }

            # ── Startups ──────────────────────────────────────────────────────────────────
            { spawn-at-startup._args = [ "fcitx5" ]; }
            { spawn-at-startup._args = [ "noctalia" ]; }
            { spawn-at-startup._args = [ "mcontrolcenter" ]; }
          ];

        debug = {
          honor-xdg-activation-with-invalid-serial = { };
        };

        # ── Binds ─────────────────────────────────────────────────────────────────────
        binds = {
          # Apps
          "Mod+Return" = {
            _props.hotkey-overlay-title = "Open Terminal";
            spawn = "kitty";
          };
          "Mod+Shift+Return" = {
            _props.hotkey-overlay-title = "Open floating Terminal";
            spawn-sh = "kitty --class=floating.kitty";
          };
          "Mod+B" = {
            _props.hotkey-overlay-title = "Open Zen Browser";
            spawn = "zen-beta";
          };
          "Mod+Z" = {
            _props.hotkey-overlay-title = "Open Anki";
            spawn = "anki";
          };
          "Mod+Shift+E" = {
            _props.hotkey-overlay-title = "Open files";
            spawn = "nautilus";
          };
          "Mod+E" = {
            _props.hotkey-overlay-title = "Open yazi";
            spawn-sh = "kitty -e fish -c \"yazi\"";
          };
          "Control+Shift+Escape" = {
            _props.hotkey-overlay-title = "Open btop++";
            spawn-sh = "kitty -e --class=floating.btop btop";
          };

          # Navigation
          "Mod+MouseBack" = {
            _props.repeat = false;
            focus-workspace-down = { };
          };
          "Mod+MouseForward" = {
            _props.repeat = false;
            focus-workspace-up = { };
          };
          "Mod+O" = {
            _props.repeat = false;
            toggle-overview = { };
          };
          "Mod+Q" = {
            _props.repeat = false;
            close-window = { };
          };

          "Mod+Left".focus-column-left = { };
          "Mod+Down".focus-window-down = { };
          "Mod+Up".focus-window-up = { };
          "Mod+Right".focus-column-right = { };
          "Mod+H".focus-column-left = { };
          "Mod+J".focus-window-down = { };
          "Mod+K".focus-window-up = { };
          "Mod+L".focus-column-right = { };

          "Mod+Shift+Left".move-column-left = { };
          "Mod+Shift+Down".move-window-down = { };
          "Mod+Shift+Up".move-window-up = { };
          "Mod+Shift+Right".move-column-right = { };
          "Mod+Shift+H".move-column-left = { };
          "Mod+Shift+J".move-window-down = { };
          "Mod+Shift+K".move-window-up = { };
          "Mod+Shift+L".move-column-right = { };

          "Mod+Alt+H".focus-column-first = { };
          "Mod+Alt+L".focus-column-last = { };
          "Mod+Alt+Shift+H".move-column-to-first = { };
          "Mod+Alt+Shift+L".move-column-to-last = { };

          "Mod+Ctrl+Left".focus-monitor-left = { };
          "Mod+Ctrl+Down".focus-monitor-down = { };
          "Mod+Ctrl+Up".focus-monitor-up = { };
          "Mod+Ctrl+Right".focus-monitor-right = { };
          "Mod+Ctrl+H".focus-monitor-left = { };
          "Mod+Ctrl+J".focus-monitor-down = { };
          "Mod+Ctrl+K".focus-monitor-up = { };
          "Mod+Ctrl+L".focus-monitor-right = { };

          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

          "Mod+Page_Down".focus-workspace-down = { };
          "Mod+Page_Up".focus-workspace-up = { };
          "Mod+U".focus-workspace-down = { };
          "Mod+I".focus-workspace-up = { };
          "Mod+Shift+Page_Down".move-column-to-workspace-down = { };
          "Mod+Shift+Page_Up".move-column-to-workspace-up = { };
          "Mod+Shift+U".move-column-to-workspace-down = { };
          "Mod+Shift+I".move-column-to-workspace-up = { };

          "Mod+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            focus-workspace-down = { };
          };
          "Mod+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            focus-workspace-up = { };
          };
          "Mod+Shift+WheelScrollDown" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-down = { };
          };
          "Mod+Shift+WheelScrollUp" = {
            _props.cooldown-ms = 150;
            move-column-to-workspace-up = { };
          };

          "Mod+WheelScrollRight".focus-column-right = { };
          "Mod+WheelScrollLeft".focus-column-left = { };
          "Mod+Ctrl+WheelScrollRight".move-column-right = { };
          "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
          "Mod+Alt+WheelScrollDown".focus-column-right = { };
          "Mod+Alt+WheelScrollUp".focus-column-left = { };
          "Mod+Ctrl+Alt+WheelScrollDown".move-column-right = { };
          "Mod+Ctrl+Alt+WheelScrollUp".move-column-left = { };

          # Workspaces
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;
          "Mod+Shift+7".move-column-to-workspace = 7;
          "Mod+Shift+8".move-column-to-workspace = 8;
          "Mod+Shift+9".move-column-to-workspace = 9;

          # Window Manipulation
          "Mod+BracketLeft".consume-or-expel-window-left = { };
          "Mod+BracketRight".consume-or-expel-window-right = { };
          "Mod+Comma".consume-window-into-column = { };
          "Mod+Period".expel-window-from-column = { };

          "Mod+D" = {
            _props.repeat = false;
            switch-preset-column-width = { };
          };
          "Mod+R" = {
            _props.repeat = false;
            switch-preset-column-width-back = { };
          };
          "Mod+Shift+D".switch-preset-window-height = { };
          "Mod+Ctrl+D".reset-window-height = { };
          "Mod+F" = {
            _props.repeat = false;
            maximize-column = { };
          };
          "Mod+Shift+F".fullscreen-window = { };
          "Mod+Ctrl+F".expand-column-to-available-width = { };
          "Mod+C".center-column = { };

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+A".toggle-window-floating = { };
          "Mod+Shift+A".switch-focus-between-floating-and-tiling = { };
          "Mod+W".toggle-column-tabbed-display = { };
          "Mod+Shift+S" = {
            _props.hotkey-overlay-title = "Snipping Tool";
            screenshot._props.show-pointer = false;
          };
          "Mod+X" = {
            _props.hotkey-overlay-title = "Toggle transparency";
            toggle-window-rule-opacity = { };
          };
          "Mod+Shift+Insert" = {
            _props.hotkey-overlay-title = "Toggle inhibit shortcuts";
            toggle-keyboard-shortcuts-inhibit = { };
          };
          "Mod+Slash" = {
            _props.hotkey-overlay-title = "Show this menu";
            show-hotkey-overlay = { };
          };

          # Noctalia
          "Alt+Space" = {
            _props = {
              hotkey-overlay-title = "Application Launcher";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle launcher";
          };
          "Mod+M" = {
            _props = {
              hotkey-overlay-title = "Control Center";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle control-center";
          };
          "Mod+Shift+M" = {
            _props = {
              hotkey-overlay-title = "Settings";
              repeat = false;
            };
            spawn-sh = "noctalia msg settings-toggle";
          };
          "Mod+V" = {
            _props = {
              hotkey-overlay-title = "Clipboard History";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle clipboard";
          };
          "Mod+Shift+Delete" = {
            _props = {
              hotkey-overlay-title = "Clear Clipboard History";
              repeat = false;
            };
            spawn-sh = "noctalia msg clipboard-clear";
          };
          "Mod+Shift+C" = {
            _props = {
              hotkey-overlay-title = "Calendar";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle control-center calendar";
          };
          "Mod+Delete" = {
            _props = {
              hotkey-overlay-title = "Session Menu";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle session";
          };
          "Mod+Alt+M" = {
            _props = {
              hotkey-overlay-title = "System Monitor";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle control-center system";
          };
          "Mod+P" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Media Panel";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle control-center media";
          };
          "Mod+Shift+P" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Play/Pause media";
              repeat = false;
            };
            spawn-sh = "noctalia msg media toggle";
          };
          "Mod+Shift+N" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Next media";
              repeat = false;
            };
            spawn-sh = "noctalia msg media next";
          };
          "Mod+Shift+B" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Previous media";
              repeat = false;
            };
            spawn-sh = "noctalia msg media previous";
          };
          "Mod+Shift+W" = {
            _props = {
              hotkey-overlay-title = "Set Wallpaper";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle wallpaper";
          };
          "Mod+N" = {
            _props = {
              hotkey-overlay-title = "Notifications Panel";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle control-center notifications";
          };
          "Mod+Alt+N" = {
            _props = {
              hotkey-overlay-title = "Clear active notifications";
              repeat = false;
            };
            spawn-sh = "noctalia msg notification-clear-active";
          };
          "Mod+Shift+Alt+N" = {
            _props = {
              hotkey-overlay-title = "Clear all notifications";
              repeat = false;
            };
            spawn-sh = "noctalia msg notification-clear-history";
          };
          "Mod+Ctrl+N" = {
            _props = {
              hotkey-overlay-title = "Toggle DND";
              repeat = false;
            };
            spawn-sh = "noctalia msg notification-dnd-toggle";
          };
          "Mod+Alt+Up" = {
            _props = {
              hotkey-overlay-title = "Toggle Bar Visibility";
              repeat = false;
            };
            spawn-sh = "noctalia msg bar-toggle";
          };
          "Mod+Alt+Down" = {
            _props = {
              hotkey-overlay-title = "Toggle Dock Visibility";
              repeat = false;
            };
            spawn-sh = "noctalia msg dock-toggle";
          };
          "Mod+Insert" = {
            _props = {
              hotkey-overlay-title = "Cycle power profiles";
              repeat = false;
            };
            spawn-sh = "noctalia msg power-cycle";
          };
          "Mod+Alt+Space" = {
            _props = {
              hotkey-overlay-title = "Window Switcher access";
              repeat = false;
            };
            spawn-sh = "noctalia msg panel-toggle launcher \"/win\"";
          };

          "Mod+F12" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Increase volume";
            };
            spawn-sh = "noctalia msg volume-up";
          };
          "Mod+F11" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Decrease volume";
            };
            spawn-sh = "noctalia msg volume-down";
          };
          "Mod+F10" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Mute volume";
            };
            spawn-sh = "noctalia msg volume-mute";
          };
          "Mod+F9" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Mute microphone";
              repeat = false;
            };
            spawn-sh = "noctalia msg mic-mute";
          };

          "Mod+F1" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Decrease brightness";
            };
            spawn-sh = "noctalia msg brightness-down";
          };
          "Mod+F2" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Increase brightness";
            };
            spawn-sh = "noctalia msg brightness-up";
          };
          "Mod+F3" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Toggle Night light";
            };
            spawn-sh = "noctalia msg nightlight-toggle";
          };

          "Mod+Shift+F1" = {
            _props = {
              repeat = false;
              allow-when-locked = true;
              hotkey-overlay-title = "Set minimum brightness (1)";
            };
            spawn-sh = "noctalia msg brightness-set 1";
          };
          "Mod+Shift+F2" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Set maximum brightness (100)";
              repeat = false;
            };
            spawn-sh = "noctalia msg brightness-set 100";
          };
          "Mod+Shift+F3" = {
            _props = {
              allow-when-locked = true;
              hotkey-overlay-title = "Force Toggle Night light";
              repeat = false;
            };
            spawn-sh = "noctalia msg nightlight-force-toggle";
          };
        };
      };
    };

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    home = {
      sessionVariables = {
        NIXOS_OZONE_WL = 1;
        # _JAVA_AWT_WM_NONREPARENTING = 1;
      };

      packages = with pkgs; [
        libsecret
        nautilus
        papers
        wl-clipboard
      ];
    };
  };
}
