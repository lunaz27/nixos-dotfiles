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

  system.nixos.tags = [ "Desktop" ];
  modules = {
    containers = {
      testbox.enable = true;
    };

    core = {
      display = {
        auto-login.enable = false;
        elyprismlauncher.enable = false;
        fonts.enable = true;
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
          enable = true;
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
        git.enable = true;
        global-programs.enable = true;
        gvfs.enable = true;
        keyd.enable = true;
        libimobiledevice.enable = false;
        logind.enable = false;
        mcontrolcenter.enable = false;
        network.enable = true;
        openssh.enable = true;
        polkit.enable = false;
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
