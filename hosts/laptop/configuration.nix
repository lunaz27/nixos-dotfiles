{
  inputs,
  ...
}:

{
  # NOTE: MSI laptop specs:
  # - Name: GF63 Thin 11UD
  # - Board: MS-16R6 (REV:1.0)
  # - CPU: Intel i5-11400H (12)
  # - iGPU: Intel UHD Graphics
  # - dGPU: NVIDIA GeForce RTX 3050Ti Mobile
  # - RAM: (2x8) DDR4 16GiB
  # - Storage: NVME SSD 512GiB (Gen3)
  # - Display: 15" 1920x1080@60Hz
  # - Battery: MSI BIF0_9
  # - Keyboard: Single backlid keyboard (Red)
  # - Weight: 1.86 kg
  # - Cooling: 1 Fan

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
        elyprismlauncher.enable = false;
        fonts.enable = true;
        gnome.enable = false;
        kde-plasma.enable = false;
        ly.enable = false;
        portals.enable = true;
        steam = {
          enable = false;
          features = {
            protonGE = true;
            gamemode = true;
            mangoHud = true;
          };
        };
      };

      hardware = {
        amd-gpu.enable = false;
        audio.enable = true;
        bluetooth.enable = true;
        btrfs.enable = true;
        intel.enable = true;
        keyboard.enable = true;
        msi = {
          enable = true;
          ec = {
            preset = "turbo";
            coolerBoost = false;
            webcamBlock = false;
            kbdBacklight = 3;
          };
        };
        nvidia-disable.enable = false;
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
        sops.enable = true;
        vm-variant.enable = true;
      };

      services = {
        auto-login.enable = true;
        git.enable = true;
        global-programs.enable = true;
        gvfs.enable = true;
        keyd.enable = true;
        libimobiledevice.enable = false;
        logind.enable = true;
        mcontrolcenter.enable = true;
        minecraft-server.enable = false;
        network = {
          enable = true;
          isRouterDnsBroken = false;
        };
        openssh.enable = true;
        polkit = {
          enable = false;
          useSoteriaFrontend = false;
        };
        power = {
          enable = true;
          mode = "performance";
        };
        qemu = {
          enable = true;
          features = {
            gui = true;
            windowsSupport = false;
            usbSharing = false;
            clipboardSharing = true;
          };
        };
        tailscale.enable = false;
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
        wol = {
          enable = false;
          interface = "eno1";
        };
        zram.enable = true;
      };
    };

    specialisation = {
      gaming = {
        enable = true;
        platform = "laptop";
      };

      travel.enable = true;

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
