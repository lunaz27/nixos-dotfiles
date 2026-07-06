{
  inputs,
  ...
}:

{
  # ╔────────────────────────────────────────────────────────────╗
  # │.---..---.,-.  .---. .---..-. .-..-..-..-.  /. /..-..-..--. │
  # │| |'_| |- | /-.  -|| `| |'| |=| || || .` |  || ||| || || \ \│
  # │`-'-/`-'  `---'`---'  `-' `-' `-'`-'`-'`-'  -- --`----'`-'-'│
  # ╚────────────────────────────────────────────────────────────╝

  # WARN: DO NOT change the state version!
  system.stateVersion = "25.11";

  imports = [
    # ── Hardware ──────────────────────────────────────────────────────────────────
    ./hardware-configuration.nix

    # ── Disko ─────────────────────────────────────────────────────────────────────
    # inputs.disko.nixosModules.disko
    # ./disk-config.nix

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
      amd-gpu.enable = false;
      audio.enable = true;
      auto-login.enable = true;
      bluetooth.enable = true;
      btrfs.enable = true;
      disabled.enable = true;
      experimental-features.enable = true;
      fonts.enable = true;
      git.enable = true;
      global-pkgs.enable = true;
      intel.enable = true;
      kernel-cachyos.enable = true;
      kernel-latest.enable = false;
      kernel-zen.enable = true;
      keyboard.enable = true;
      keyd.enable = true;
      libimobiledevice.enable = false;
      ly.enable = false;
      mcontrolcenter.enable = true;
      network.enable = true;
      nh.enable = true;
      niri-cachix.enable = true;
      nvidia-hybrid.enable = true;
      polkit.enable = true;
      portals.enable = false;
      programs.enable = true;
      ryzen.enable = false;
      services.enable = true;
      systemd-boot.enable = true;
      timezone.enable = true;
      touchpad.enable = true;
      users.enable = true;
      variables.enable = true;
      vm-variant.enable = true;
      zram.enable = true;
    };

    specialisation = {
      gaming = {
        enable = true;
        platform = "laptop";
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
