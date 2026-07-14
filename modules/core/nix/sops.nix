{
  lib,
  config,
  inputs,
  ...
}:

{
  options = {
    modules.core.nix.sops.enable = lib.mkEnableOption "atomic secrets management tool" // {
      default = true;
    };
  };

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = lib.mkIf config.modules.core.nix.sops.enable {
    sops = {
      defaultSopsFile = ../../../secrets/sshKeys.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/suwapotta/.config/sops/age/keys.txt";

      secrets = {
        # ── passwordHashes.yaml ───────────────────────────────────────────────────────
        "suwapotta" = {
          # owner = "root";
          neededForUsers = true;
          sopsFile = ../../../secrets/passwordHashes.yaml;
        };

        "vm-user" = {
          # owner = "root";
          neededForUsers = true;
          sopsFile = ../../../secrets/passwordHashes.yaml;
        };

        # ── sshKeys.yaml ──────────────────────────────────────────────────────────────
        "remote-builder-laptop-x86_64" = {
          # owner = "root";
          sopsFile = ../../../secrets/sshKeys.yaml;
        };

      };
    };
  };
}
