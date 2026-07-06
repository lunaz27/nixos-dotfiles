{ lib, ... }:

let
  getNixFiles =
    dir:
    let
      dirContents = builtins.readDir dir;
      validFiles = builtins.filter (
        name: name != "user-default.nix" && dirContents.${name} == "regular" && lib.hasSuffix ".nix" name
      ) (builtins.attrNames dirContents);
    in
    map (name: dir + "/${name}") validFiles;
in
{
  imports =
    (getNixFiles ./apps)
    ++ (getNixFiles ./cli)
    ++ (getNixFiles ./desktop)
    ++ (getNixFiles ./dotfiles)
    ++ (getNixFiles ./editors)
    ++ (getNixFiles ./shells)
    ++ (getNixFiles ./terminals)
    ++ (getNixFiles ./themes);
}
