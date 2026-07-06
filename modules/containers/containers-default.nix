{
  lib,
  ...
}:

let
  getNixFiles =
    dir:
    let
      dirContents = builtins.readDir dir;
      validFiles = builtins.filter (
        name:
        name != "containers-default.nix" && dirContents.${name} == "regular" && lib.hasSuffix ".nix" name
      ) (builtins.attrNames dirContents);
    in
    map (name: dir + "/${name}") validFiles;
in
{
  imports = getNixFiles ./.;
}
