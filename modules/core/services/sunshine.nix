{
  lib,
  config,
  pkgs,
  userName,
  ...
}:

let
  cfg = config.modules.core.services.sunshine;
in
{
  options = {
    modules.core.services.sunshine = {
      enable = lib.mkEnableOption "game streaming host for moonlight";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "uinput" ];
    users.users.${userName}.extraGroups = [
      "input"
      "uinput"
    ];

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;

      settings = {
        sunshine_name = "NixOS-Desktop";
        upnp = "disabled";
        gamepad = "xone";
        min_log_level = "info";
      };

      applications = {
        apps = [
          {
            name = "Desktop";
            image-path = ../../../public/images/logos/nixos-flake.png;
          }

          {
            name = "Monifactory";
            cmd = "${pkgs.elyprismlauncher}/bin/elyprismlauncher --launch Monifactory";
            image-path = "/home/${userName}/.local/share/ElyPrismLauncher/instances/Monifactory/icon.png";
          }
        ];
      };
    };
  };
}
