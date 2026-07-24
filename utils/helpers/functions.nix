{
  lib,
  ...
}:

{
  getNixFiles =
    dir:
    lib.pipe dir [
      lib.filesystem.listFilesRecursive
      (builtins.filter (lib.hasSuffix ".nix"))
    ];
}
