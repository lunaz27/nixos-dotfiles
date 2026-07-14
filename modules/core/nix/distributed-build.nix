{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.nix.distributed-build.enable = lib.mkEnableOption "remote building nixos generation";
  };

  config = lib.mkIf config.modules.core.nix.distributed-build.enable {
    nix = {
      distributedBuilds = true;

      buildMachines = [
        {
          hostName = "192.168.1.201";
          sshUser = "remotebuilder";
          sshKey = config.sops.secrets."remote-builder-laptop-x86_64".path;

          systems = [ "x86_64-linux" ];
          protocol = "ssh-ng";
          maxJobs = 32; # Ryzen 9 7950X
          speedFactor = 5; # Relative speed
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ];
          mandatoryFeatures = [ ];
        }
      ];

      extraOptions = ''
        builders-use-substitutes = true
      '';
    };

    programs.ssh.extraConfig = ''
      Host                  192.168.1.201
      User                  remotebuilder
      Port                  22
      IdentityFile          ${config.sops.secrets."remote-builder-laptop-x86_64".path}
      IdentitiesOnly        yes
      StrictHostKeyChecking accept-new
    '';
  };
}
