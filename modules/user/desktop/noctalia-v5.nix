{
  flake.homeModules."noctalia-v5" =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;

        settings = {
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };

          wallpaper = {
            enabled = true;
            default.path = ../../../images/wallpapers/astronaut.png;
          };
        };
      };
    };
}
