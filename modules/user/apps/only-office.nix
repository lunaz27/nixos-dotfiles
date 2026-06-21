{
  flake.homeModules."only-office" = {
    programs.onlyoffice = {
      enable = true;

      settings = {
        UITheme = "theme-night";
      };
    };
  };
}
