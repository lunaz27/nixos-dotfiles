{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.core.fonts.enable = lib.mkEnableOption "fonts list";
  };

  config = lib.mkIf config.modules.core.fonts.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only

        work-sans

        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];
    };
  };
}
