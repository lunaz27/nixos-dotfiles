{
  inputs,
  ...
}:

{
  # NOTE: Homeserver PC specs:
  # - Board: ASUS Prime H120M-K
  # - CPU: Intel Pentium Gold G6405 (4)
  # - iGPU: UHD Graphics 610
  # - RAM: (1x4) DDR4 4GiB
  # - Storage: HS SSD E100N 128GiB
  # - Storage: SATA 1TiB
  # - Display: 19" 1440x900@75Hz

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
      testbox.enable = false;
    };

    core = {
      display = {
        elyprismlauncher.enable = true;
        fonts.enable = false;
        gnome.enable = false;
        kde-plasma.enable = false;
        ly.enable = false;
        portals.enable = false;
        steam = {
          enable = false;
          features = {
            protonGE = false;
            gamemode = false;
            mangoHud = false;
          };
        };
      };

      hardware = {
        amd-gpu.enable = false;
        audio.enable = true;
        bluetooth.enable = false;
        btrfs.enable = false;
        intel.enable = true;
        keyboard.enable = false;
        msi = {
          enable = false;
          ec = {
            preset = null;
            coolerBoost = false;
            webcamBlock = false;
            kbdBacklight = 0;
          };
        };
        nvidia-disable.enable = false;
        nvidia-offload.enable = false;
        nvidia-sync.enable = false;
        ryzen.enable = false;
        touchpad.enable = false;
      };

      nix = {
        disabled.enable = true;
        distributed-build.enable = true;
        experimental-features.enable = true;
        nh.enable = true;
        niri-cachix.enable = false;
        remote-builder.enable = false;
        sops.enable = true;
        vm-variant.enable = false;
      };

      services = {
        auto-login.enable = false;
        git.enable = true;
        global-programs.enable = true;
        gvfs.enable = true;
        keyd.enable = true;
        libimobiledevice.enable = false;
        logind.enable = false;
        mcontrolcenter.enable = false;
        minecraft-server.enable = false;
        network = {
          enable = true;
          isRouterDnsBroken = true;
        };
        openssh.enable = true;
        polkit = {
          enable = true; # Dependency for sway.nix
          useSoteriaFrontend = false;
        };
        power = {
          enable = false;
          mode = null;
        };
        qemu = {
          enable = false;
          features = {
            gui = false;
            windowsSupport = false;
            usbSharing = false;
            clipboardSharing = false;
          };
        };
        tailscale.enable = true;
      };

      system = {
        global-pkgs.enable = true;
        kernel-cachyos = {
          enable = true;
          optimisationLevel = "v2";
        };
        kernel-latest.enable = false;
        kernel-zen.enable = false;
        systemd-boot.enable = true;
        timezone.enable = true;
        users.enable = true;
        variables.enable = false;
        wol = {
          enable = true;
          interface = "eno1";
        };
        zram.enable = true;
      };
    };

    specialisation = {
      gaming = {
        enable = false;
        platform = null;
      };

      travel.enable = false;

      virtualisation = {
        enable = false;
        features = {
          gui = false;
          windowsSupport = false;
          usbSharing = false;
          clipboardSharing = false;
        };
      };
    };
  };
}
