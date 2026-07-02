{
  flake.nixosModules."portals" =
    {
      pkgs,
      ...
    }:

    # Gnome portals for niri
    {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];

        config.common.default = "*";
      };

    };
}
