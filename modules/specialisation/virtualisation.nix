{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.modules.specialisation.virtualisation;
in
{
  options = {
    modules.specialisation.virtualisation = {
      enable = lib.mkEnableOption "qemu/kvm virtualisation";

      features = {
        gui = lib.mkEnableOption "uses virt-manager frontend";
        windowsSupport = lib.mkEnableOption "enables windows 11, etc.";
        usbSharing = lib.mkEnableOption "shared usb with host";
        clipboardSharing = lib.mkEnableOption "shared clipboard content";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    specialisation."Virtualisation".configuration = lib.mkMerge [
      # ── Core ──────────────────────────────────────────────────────────────────────
      {
        system.nixos.tags = [ "Virtualisation" ];

        users.users."suwapotta".extraGroups = [
          "libvirtd"
          "kvm"
        ];

        virtualisation = {
          libvirtd = {
            enable = true;

            qemu = {
              package = pkgs.qemu_kvm;
              runAsRoot = true;
            };
          };
        };
      }

      # ── GUI ───────────────────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.gui {
        programs.virt-manager.enable = true;
      })

      # ── Windows ───────────────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.windowsSupport {
        virtualisation.libvirtd.qemu.swtpm.enable = true;
      })

      # ── USB ───────────────────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.usbSharing {
        virtualisation.spiceUSBRedirection.enable = true;
      })

      # ── Clipboard ─────────────────────────────────────────────────────────────────
      (lib.mkIf cfg.features.clipboardSharing {
        services.spice-vdagentd.enable = true;
      })
    ];
  };
}
