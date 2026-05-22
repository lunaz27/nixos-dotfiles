{
  flake.nixosModules."qemu" =
    { pkgs, ... }:

    {
      specialisation."Virtualisation".configuration = {
        system.nixos.tags = [ "Virtualisation" ];

        users.users."suwapotta".extraGroups = [
          "libvirtd"
          "kvm"
        ];

        programs.virt-manager.enable = true;
        virtualisation = {
          libvirtd = {
            enable = true;

            qemu = {
              package = pkgs.qemu_kvm;
              runAsRoot = true;
              # swtpm.enable = true; # Required for Windows 11 VMs
            };

          };

          # spiceUSBRedirection.enable = true;
        };

        # Clipboard sharing
        services.spice-vdagentd.enable = true;
      };
    };
}
