{
  flake.nixosModules."latest-kernel" =
    {
      pkgs,
      ...
    }:

    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
