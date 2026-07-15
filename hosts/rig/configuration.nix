{
  inputs,
  ...
}:

{
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

  system.nixos.tags = [ "Rig" ];
  modules = {
    containers = {
      testbox.enable = false;
    };

    core = {
      display = {
        auto-login.enable = false;
        elyprismlauncher.enable = true;
        fonts.enable = false;
        gnome.enable = true;
        ly.enable = false;
        portals.enable = false;
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
        bluetooth.enable = false;
        btrfs.enable = false;
        intel.enable = true;
        keyboard.enable = false;
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
        ryzen.enable = false;
        touchpad.enable = false;
      };

      nix = {
        disabled.enable = true;
        distributed-build.enable = false;
        experimental-features.enable = true;
        nh.enable = true;
        niri-cachix.enable = false;
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
        logind.enable = false;
        mcontrolcenter.enable = false;
        network.enable = true;
        openssh.enable = false;
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
          optimisationLevel = "v2";
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
        enable = false;
        platform = null;
      };

      travel.enable = false;

      virtualisation = {
        enable = false;
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
