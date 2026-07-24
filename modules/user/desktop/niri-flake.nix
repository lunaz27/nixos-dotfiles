{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.modules.user.desktop.niri-flake;
in
{
  options.modules.user.desktop.niri-flake = {
    enable = lib.mkEnableOption "niri window manager";

    release = lib.mkOption {
      type = lib.types.enum [
        "nixpkgs"
        "stable"
        "unstable"
      ];
      default = "unstable";
      description = "version/channel of Niri to install";
    };
  };

  imports = [
    inputs.niri-flake.homeModules.niri
  ];

  config = lib.mkIf cfg.enable {
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
        xwayland-satellite
      ];
    };

    programs.niri = {
      enable = true;

      package =
        {
          "nixpkgs" = pkgs.niri;
          "stable" = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;
          "unstable" = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
        }
        .${cfg.release};
    };
  };
}
