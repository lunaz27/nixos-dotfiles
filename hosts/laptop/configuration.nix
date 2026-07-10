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
      display = {
        auto-login.enable = true;
        fonts.enable = true;
        ly.enable = false;
        portals.enable = true;
      };

      hardware = {
        amd-gpu.enable = false;
        audio.enable = true;
        bluetooth.enable = true;
        btrfs.enable = true;
        intel.enable = true;
        keyboard.enable = true;
        nvidia-offload.enable = true;
        nvidia-sync.enable = false;
        ryzen.enable = false;
        touchpad.enable = true;
      };

      nix = {
        disabled.enable = true;
        distributed-build.enable = true;
        experimental-features.enable = true;
        nh.enable = true;
        niri-cachix.enable = true;
        remote-builder.enable = false;
        vm-variant.enable = true;
      };

      services = {
        git.enable = true;
        global-programs.enable = true;
        gvfs.enable = true;
        keyd.enable = true;
        libimobiledevice.enable = false;
        mcontrolcenter.enable = true;
        network.enable = true;
        openssh.enable = false;
        polkit.enable = false;
        power.enable = true;
        qemu = {
          enable = false;
          features = {
            gui = true;
            windowsSupport = false;
            usbSharing = false;
            clipboardSharing = true;
          };
        };
      };

      system = {
        global-pkgs.enable = true;
        kernel-cachyos = {
          enable = false;
          optimisationLevel = "v4";
        };
        kernel-latest.enable = false;
        kernel-zen.enable = true;
        systemd-boot.enable = true;
        timezone.enable = true;
        users.enable = true;
        variables.enable = true;
        zram.enable = true;
      };
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
