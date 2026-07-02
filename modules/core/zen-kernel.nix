{
  flake.nixosModules."zen-kernel" =
    {
      pkgs,
      ...
    }:

    {
      boot.kernelPackages = pkgs.linuxPackages_zen;
    };
}
