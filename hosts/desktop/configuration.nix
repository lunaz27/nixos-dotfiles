{
  inputs,
  ...
}:

{
  # ╔───────────────────────────────────────────────────╗
  # │ ____            _    _                ____   ____ │
  # │|  _ \  ___  ___| | _| |_ ___  _ __   |  _ \ / ___|│
  # │| | | |/ _ \/ __| |/ / __/ _ \| '_ \  | |_) | |    │
  # │| |_| |  __/\__ \   <| || (_) | |_) | |  __/| |___ │
  # │|____/ \___||___/_|\_\\__\___/| .__/  |_|    \____|│
  # │                              |_|                  │
  # ╚───────────────────────────────────────────────────╝

  # WARN: DO NOT change the state version!
  system.stateVersion = "26.05";

  imports = [
    # ── Hardware ──────────────────────────────────────────────────────────────────
    ./hardware-configuration.nix

    # ── Disko ─────────────────────────────────────────────────────────────────────
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    # ── Home Manager ──────────────────────────────────────────────────────────────
    inputs.home-manager.nixosModules.home-manager
    ./home.nix

    # ── Modules ───────────────────────────────────────────────────────────────────
    ../../modules/core/core-default.nix
    ../../modules/containers/containers-default.nix
    ../../modules/specialisation/specialisation-default.nix
  ];

  modules = {
    containers = {
      testbox.enable = true;
    };

    core = {
      amd-gpu.enable = true;
      audio.enable = true;
      auto-login.enable = false;
      bluetooth.enable = true;
      btrfs.enable = true;
      disabled.enable = true;
      distributed-build.enable = false;
      experimental-features.enable = true;
      fonts.enable = true;
      git.enable = true;
      global-pkgs.enable = true;
      intel.enable = false;
      kernel-cachyos.enable = true;
      kernel-latest.enable = false;
      kernel-zen.enable = true;
      keyboard.enable = true;
      keyd.enable = true;
      libimobiledevice.enable = false;
      ly.enable = true;
      mcontrolcenter.enable = false;
      network.enable = true;
      nh.enable = true;
      niri-cachix.enable = true;
      nvidia-hybrid.enable = false;
      openssh.enable = true;
      polkit.enable = false;
      portals.enable = true;
      programs.enable = true;
      ryzen.enable = true;
      services.enable = true;
      systemd-boot.enable = true;
      timezone.enable = true;
      touchpad.enable = false;
      users = {
        enable = true;
        remoteBuilder = false;
      };
      variables.enable = true;
      vm-variant.enable = true;
      zram.enable = true;
    };

    specialisation = {
      gaming = {
        enable = true;
        platform = "desktop";
      };

      virtualisation = {
        enable = true;
        features = {
          gui = true;
          windowsSupport = false;
          usbSharing = false;
          clipboardSharing = true;
        };
      };
    };
  };
}
