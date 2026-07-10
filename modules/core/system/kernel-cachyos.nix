{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.modules.core.system.kernel-cachyos;
in
{
  options = {
    modules.core.system.kernel-cachyos = {
      enable = lib.mkEnableOption "cachyos kernel enable switch";
      optimisationLevel = lib.mkOption {
        default = "latest";
        type = lib.types.enum [
          "latest"
          "v3"
          "v4"
          "zen4"
        ];
      };
    };
  };

  # NOTE: Search for supported/compatible versions
  # $ /lib64/ld-linux-x86-64.so.2 --help | rg supported
  config = lib.mkIf cfg.enable {
    boot.kernelPackages =
      {
        "latest" = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
        "v3" = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
        "v4" = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
        "zen4" = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
      }
      .${cfg.optimisationLevel};

    # NOTE: List of all possible kernel options:
    # $ nix flake show github:xddxdd/nix-cachyos-kernel/release
    # WARN: Only use one of the two overlays
    nixpkgs.overlays = [
      # Use nixpkgs from your environment, nixpkgs.config will apply.
      # Has small chance of kernel modules not being compatible with kernel version.
      inputs.nix-cachyos-kernel.overlays.default

      # Alternatively, use the exact nixpkgs revision as defined in this repo.
      # Guarantees you have binary cache, but initializes another nixpkgs instance.
      # inputs.nix-cachyos-kernel.overlays.pinned
    ];

    nix.settings = {
      substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
      ];

      trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}
