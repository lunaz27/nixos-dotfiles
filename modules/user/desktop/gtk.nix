{
  flake.homeModules."gtk" =
    {
      pkgs,
      ...
    }:

    {
      gtk = {
        enable = true;

        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        font = {
          name = "Adwaita Sans";
          size = 10;
        };

        cursorTheme = {
          name = "Bibata-Modern-Classic";
          size = 24;
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };

        gtk4 = {
          theme = null;
          extraConfig = {
            gtk-application-prefer-dark-theme = 1;
          };
        };
      };
    };
}
