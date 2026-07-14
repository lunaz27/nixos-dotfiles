{
  lib,
  config,
  ...
}:

let
  cfg = config.modules.user.cli.ssh-client;
in
{
  options = {
    modules.user.cli.ssh-client = {
      enable = lib.mkEnableOption "user-level ssh client settings";
      keyGen = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "desktop"
            "laptop"
          ]
        );
        default = null;
        description = "which machine to generate ssh key from sops";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/github_ed25519";
          IdentitiesOnly = "yes";
        };

        "desktop" = {
          HostName = "192.168.1.201";
          User = "suwapotta";
          Port = "24";
        };

        "laptop" = {
          HostName = "192.168.1.27";
          User = "suwapotta";
          Port = "24";
        };
      };
    };

    sops.secrets = lib.mkIf (cfg.keyGen != null) {
      "id_${cfg.keyGen}" = {
        sopsFile = ../../../secrets/sshKeys.yaml;
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };

      "github_${cfg.keyGen}" = {
        sopsFile = ../../../secrets/sshKeys.yaml;
        path = "${config.home.homeDirectory}/.ssh/github_ed25519";
      };
    };
  };
}
