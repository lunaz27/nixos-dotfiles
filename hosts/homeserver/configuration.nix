{
  inputs,
  helperLib,
  stateVersion,
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
  system.stateVersion = stateVersion;

  imports = [
    # ── Hardware ──────────────────────────────────────────────────────────────────
    ./hardware-configuration.nix

    # ── Disko ─────────────────────────────────────────────────────────────────────
    inputs.disko.nixosModules.disko
    ./disk-config.nix

    # ── Home Manager ──────────────────────────────────────────────────────────────
    inputs.home-manager.nixosModules.home-manager
    ./home.nix
  ]
  # ── Modules ───────────────────────────────────────────────────────────────────
  ++ (helperLib.getNixFiles ../../modules/core)
  ++ (helperLib.getNixFiles ../../modules/containers)
  ++ (helperLib.getNixFiles ../../modules/specialisation);

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
        moonlight.enable = false;
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
        path.enable = true;
        remote-builder.enable = false;
        sops.enable = true;
        vm-variant.enable = false;
      };

      services = {
        git.enable = true;
        global-programs.enable = true;
        gvfs.enable = true;
        keyd.enable = true;
        libimobiledevice.enable = false;
        logind = {
          enable = false;
          ignoreLidClosing = false;
        };
        mcontrolcenter.enable = false;
        minecraft-server.enable = false;
        network = {
          enable = true;
          isRouterDnsBroken = true;
        };
        niri-autologin.enable = false;
        openssh.enable = true;
        polkit = {
          enable = true; # Dependency for sway.nix
          useSoteriaFrontend = false;
        };
        power = {
          enable = false;
          mode = null;
        };
        sunshine.enable = false;
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
        tty-autologin.enable = false;
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

      remote-play.enable = false;

      server.enable = false;

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
