{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    modules.user.apps.libre-office.enable = lib.mkEnableOption "libre office - productivity suite";
  };

  config = lib.mkIf config.modules.users.apps.libre-office.enable {
    home.packages = with pkgs; [
      libreoffice

      # NOTE: Optional spellcheck
      # hunspell
      # hunspellDicts.en-us
    ];
  };
}
