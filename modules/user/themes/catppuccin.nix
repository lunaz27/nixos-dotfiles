{
  flake.homeModules."catppuccin" =
    { inputs, ... }:

    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin = {
        enable = true;
        autoEnable = false;

        flavor = "mocha";
        accent = "sapphire";

        ### apps
        anki.enable = true;
        zathura.enable = true;

        ### cli
        bat.enable = true;
        btop.enable = true;
        cava.enable = true;
        fzf.enable = true;
        lazygit.enable = true;
        yazi.enable = true;

        ### desktop
        fcitx5 = {
          enable = true;
          enableRounded = true;
        };

        ### editors

        ### shells
        fish.enable = true;
        eza.enable = true;
        starship.enable = true;

        ### terminals
        kitty.enable = true;
      };
    };
}
