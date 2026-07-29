{
  lib,
  config,
  inputs,
  pkgs,
  userName,
  ...
}:

let
  hmCfg = config.home-manager.users.${userName}.modules.user.desktop.niri;
in
{
  config = lib.mkIf hmCfg.enable {
    # NOTE: Installs native desktop portals and gnome keyring daemon
    programs.niri = {
      enable = true;
      package = inputs.niri-flake.packages.${pkgs.stdenv.system}.niri-unstable;
    };
  };
}
