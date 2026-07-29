{
  lib,
  config,
  inputs,
  pkgs,
  userName,
  ...
}:

{
  config = lib.mkIf config.home-manager.users.${userName}.modules.user.desktop.niri.enable {
    # NOTE: Installs native desktop portals and gnome keyring daemon
    programs.niri = {
      enable = true;
      package = inputs.niri-flake.packages.${pkgs.stdenv.system}.niri-unstable;
    };
  };
}
