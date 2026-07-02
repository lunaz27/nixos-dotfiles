{
  flake.homeModules."fcitx5" =
    {
      pkgs,
      ...
    }:

    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";

        fcitx5 = {
          waylandFrontend = true;

          addons = with pkgs; [
            kdePackages.fcitx5-unikey
            fcitx5-mozc
            kdePackages.fcitx5-qt
            fcitx5-gtk
            qt6Packages.fcitx5-configtool
          ];

          settings = {
            inputMethod = {
              "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                DefaultIM = "unikey";
              };
              "Groups/0/Items/0" = {
                Name = "keyboard-us";
                Layout = "";
              };
              "Groups/0/Items/1" = {
                Name = "unikey";
                Layout = "";
              };
              "Groups/0/Items/2" = {
                Name = "mozc";
                Layout = "";
              };
              GroupOrder = {
                "0" = "Default";
              };
            };

            globalOptions = {
              Hotkey = {
                EnumerateWithTriggerKeys = "True";
                EnumerateForwardKeys = "";
                EnumerateBackwardKeys = "";
                EnumerateSkipFirst = "False";
                ModifierOnlyKeyTimeout = 250;
              };
              "Hotkey/TriggerKeys" = {
                "0" = "Control+space";
                "1" = "Zenkaku_Hankaku";
                "2" = "Hangul";
              };
              "Hotkey/ActivateKeys"."0" = "Hangul_Hanja";
              "Hotkey/DeactivateKeys"."0" = "Hangul_Romaja";
              "Hotkey/AltTriggerKeys"."0" = "Shift_L";
              "Hotkey/EnumerateGroupForwardKeys"."0" = "Super+space";
              "Hotkey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
              "Hotkey/PrevPage"."0" = "Up";
              "Hotkey/NextPage"."0" = "Down";
              "Hotkey/PrevCandidate"."0" = "Shift+Tab";
              "Hotkey/NextCandidate"."0" = "Tab";
              "Hotkey/TogglePreedit"."0" = "Control+Alt+P";

              Behavior = {
                ActiveByDefault = "False";
                resetStateWhenFocusIn = "No";
                ShareInputState = "No";
                PreeditEnabledByDefault = "True";
                ShowInputMethodInformation = "True";
                showInputMethodInformationWhenFocusIn = "False";
                CompactInputMethodInformation = "True";
                ShowFirstInputMethodInformation = "True";
                DefaultPageSize = 5;
                OverrideXkbOption = "False";
                CustomXkbOption = "";
                EnabledAddons = "";
                DisabledAddons = "";
                PreloadInputMethod = "True";
                AllowInputMethodForPassword = "False";
                ShowPreeditForPassword = "False";
                AutoSavePeriod = 30;
              };
            };

            addons = {
              classicui.globalSection = {
                "Vertical Candidate List" = "False";
                WheelForPaging = "True";
                Font = "Work Sans 11";
                MenuFont = "Work Sans 11";
                TrayFont = "Work Sans Semibold 11";
                TrayOutlineColor = "#000000";
                TrayTextColor = "#ffffff";
                PreferTextIcon = "False";
                ShowLayoutNameInIcon = "True";
                UseInputMethodLanguageToDisplayText = "True";
                PerScreenDPI = "False";
                ForceWaylandDPI = 0;
                EnableFractionalScale = "True";
              };
            };
          };
        };
      };
    };
}
