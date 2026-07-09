{
  lib,
  config,
  inputs,
  ...
}:

{
  options = {
    modules.core.kernel-cachyos.enable = lib.mkEnableOption "cachyos kenel setup";
  };

  # NOTE: List of all possible kernel options:
  # $ nix flake show github:xddxdd/nix-cachyos-kernel/release
  config = lib.mkIf config.modules.core.kernel-cachyos.enable {
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
