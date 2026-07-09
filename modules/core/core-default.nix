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
        name: name != "core-default.nix" && dirContents.${name} == "regular" && lib.hasSuffix ".nix" name
      ) (builtins.attrNames dirContents);
    in
    map (name: dir + "/${name}") validFiles;
in
{
  imports =
    (getNixFiles ./display)
    ++ (getNixFiles ./hardware)
    ++ (getNixFiles ./nix)
    ++ (getNixFiles ./services)
    ++ (getNixFiles ./system);
}
