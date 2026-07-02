{
  flake.homeModules."libre-office" =
    {
      pkgs,
      ...
    }:

    {
      home.packages = with pkgs; [
        # Base Libre-office
        libreoffice

        # NOTE: Optional spellcheck
        # hunspell
        # hunspellDicts.uk_UA
      ];
    };
}
