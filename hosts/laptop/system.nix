{ self, inputs, ... }:

{
  flake.nixosConfigurations."laptop" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit self inputs; };

    modules = [
      ### host
      ./configuration.nix
      ./hardware-configuration.nix

      ### disko
      # inputs.disko.nixosModules.disko
      # ./disk-config.nix

      ### home-manager
      ./home-manager.nix

      ### core
      self.nixosModules."audio"
      self.nixosModules."auto-login"
      self.nixosModules."bluetooth"
      self.nixosModules."btrfs"
      self.nixosModules."experimental"
      self.nixosModules."fonts"
      self.nixosModules."git"
      self.nixosModules."intel"
      self.nixosModules."keyd"
      # self.nixosModules."latest-kernel"
      # self.nixosModules."libimobiledevice"
      self.nixosModules."nano"
      self.nixosModules."network"
      self.nixosModules."nh"
      self.nixosModules."niri-cache"
      self.nixosModules."nvidia"
      self.nixosModules."packages"
      self.nixosModules."polkit"
      self.nixosModules."portals"
      self.nixosModules."programs"
      self.nixosModules."services"
      self.nixosModules."systemd-boot"
      self.nixosModules."timezone"
      self.nixosModules."touchpad"
      self.nixosModules."users"
      self.nixosModules."variables"
      self.nixosModules."vm-variant"
      self.nixosModules."zen-kernel"
      self.nixosModules."zram"

      ### specialisation
      self.nixosModules."cachyos-kernel"
      self.nixosModules."gaming"
      self.nixosModules."qemu"
    ];
  };
}
