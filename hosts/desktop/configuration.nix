{
  inputs,
  stateVersion,
  ...
}:

{
  # NOTE: Desktop PC specs:
  # - Board: PRO X870E-P WIFI (MS-7E70) (2.0)
  # - CPU: AMD Ryzen 9 7950X (32)
  # - iGPU: AMD Raphael
  # - dGPU: AMD Radeon RX 9060XT
  # - RAM: (2x16) DDR5 32GiB Gskill Ripjaws
  # - Storage: NVME SSD Western 1TiB (Gen4)
  # - Display: 24" 1920x1080@75Hz
  # - Cooling: Frozen A620 SLK (Dual Tower)
  # - PSU: EVGA Supernova 750W (Gold)
  # - Case: Linktech Bahamut ATX

  # WARN: DO NOT change the state version!
  system.stateVersion = stateVersion;

  # TODO: Module for:
  nix = {
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];

    channel.enable = false;
  };
  systemd.enableStrictShellChecks = true;

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
      display = {
        elyprismlauncher.enable = false;
        fonts.enable = true;
        gnome.enable = false;
        kde-plasma.enable = false;
        ly.enable = true;
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
        amd-gpu.enable = true;
        audio.enable = true;
        bluetooth.enable = true;
        btrfs.enable = true;
        intel.enable = false;
        keyboard.enable = true;
        msi = {
          enable = false;
          ec = {
            preset = "turbo";
            coolerBoost = false;
            webcamBlock = false;
            kbdBacklight = 3;
          };
        };
        nvidia-disable.enable = false;
        nvidia-offload.enable = false;
        nvidia-sync.enable = false;
        ryzen.enable = true;
        touchpad.enable = false;
      };

      nix = {
        disabled.enable = true;
        distributed-build.enable = false;
        experimental-features.enable = true;
        nh.enable = true;
        niri-cachix.enable = true;
        remote-builder.enable = true;
        sops.enable = true;
        vm-variant.enable = true;
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
          isRouterDnsBroken = false;
        };
        openssh.enable = true;
        polkit = {
          enable = false;
          useSoteriaFrontend = false;
        };
        power = {
          enable = true;
          mode = null;
        };
        qemu = {
          enable = false;
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
          optimisationLevel = "zen4";
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
        platform = "desktop";
      };

      travel.enable = false;

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
