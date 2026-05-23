{
  flake.nixosModules."vm-variant" = {
    virtualisation.vmVariant = {
      users.extraUsers."vm-user" = {
        isNormalUser = true;

        extraGroups = [ "wheel" ];
        initialHashedPassword = "$y$j9T$DGgyvod9oxdgR0hFqbJlZ.$lX0jcBgJlHVmxxFWPo1yStGcE1H9RosrlQF.HgeIua1";
      };
    };
  };
}
