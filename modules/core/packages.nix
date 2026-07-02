{
  flake.nixosModules."packages" =
    {
      pkgs,
      ...
    }:

    {
      environment.systemPackages = with pkgs; [
        # gnumake
        just

        unzip

        wget
        curl
      ];
    };
}
