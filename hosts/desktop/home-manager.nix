{
  self,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs self; };
    backupFileExtension = "bak";

    users."suwapotta" = import ./suwapotta.nix;
  };
}
