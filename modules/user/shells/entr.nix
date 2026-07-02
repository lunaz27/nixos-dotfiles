{
  flake.homeModules."entr" =
    {
      pkgs,
      ...
    }:

    {
      home.packages = with pkgs; [
        entr
      ];
    };
}
