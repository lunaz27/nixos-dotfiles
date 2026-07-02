{
  flake.nixosModules."fonts" =
    {
      pkgs,
      ...
    }:

    {
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
