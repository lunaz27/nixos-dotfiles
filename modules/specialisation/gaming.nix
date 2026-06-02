{
  flake.nixosModules."gaming" =
    {
      lib,
      pkgs,
      ...
    }:

    {
      specialisation = {
        "Gaming".configuration = {
          system.nixos.tags = [ "Gaming" ];

          # NOTE: List of all possible options:
          # $ nix flake show github:xddxdd/nix-cachyos-kernel/release
          boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

          # Proton-GE performance boost
          boot.kernelModules = [ "ntsync" ];
          services.udev.extraRules = ''
            KERNEL=="ntsync", MODE="0666"
          '';

          hardware.nvidia = {
            prime = {
              sync.enable = lib.mkForce true;

              offload = {
                enable = lib.mkForce false;
                enableOffloadCmd = lib.mkForce false;
              };
            };

            powerManagement.finegrained = lib.mkForce false;
          };

          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "steam"
              "steam-unwrapped"
            ];
          programs.steam = {
            enable = true;
            extraCompatPackages = with pkgs; [
              proton-ge-bin
            ];
          };
        };
      };
    };
}
