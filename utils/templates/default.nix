{
  lib,
  ...
}:

let
  mkDevshellsTemplate = lang: {
    description = "Devshells Configuration";
    path = ./devshells + "/${lang}";
  };

  mkDiskoTemplate = preset: {
    description = "Disko Configuration";
    path = ./disko + "/${preset}";
  };

  devshellDirs = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./devshells)
  );

  diskoDirs = builtins.attrNames (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./disko)
  );
in
lib.genAttrs devshellDirs mkDevshellsTemplate // lib.genAttrs diskoDirs mkDiskoTemplate
