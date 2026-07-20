{
  lib,
  config,
  inputs,
  ...
}:

{
  options = {
    modules.user.themes.catppuccin.enable = lib.mkEnableOption "catppuccin colorscheme";
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  config = lib.mkIf config.modules.user.themes.catppuccin.enable {
    catppuccin = {
      enable = true;
      autoEnable = false;

      flavor = "mocha";
      accent = "sapphire";

      # ── apps ──────────────────────────────────────────────────────────────────────
      anki.enable = true;
      sioyek.enable = true;
      zathura.enable = true;

      # ── cli ───────────────────────────────────────────────────────────────────────
      bat.enable = true;
      btop.enable = true;
      cava.enable = true;
      fzf.enable = true;
      lazygit.enable = true;
      yazi.enable = true;

      # ── desktop ───────────────────────────────────────────────────────────────────
      fcitx5 = {
        enable = true;
        enableRounded = true;
      };
      qt5ct.enable = false;
      gtk.icon.enable = false;

      # ── editors ───────────────────────────────────────────────────────────────────
      nvim.enable = false;

      # ── shells ────────────────────────────────────────────────────────────────────
      fish.enable = true;
      eza.enable = true;
      starship.enable = true;

      # ── terminals ─────────────────────────────────────────────────────────────────
      kitty.enable = true;
      alacritty.enable = false;
    };
  };
}
