{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.distributed-build.enable = lib.mkEnableOption "remote building nixos generation";
  };

  config = lib.mkIf config.modules.core.distributed-build.enable {
    nix = {
      distributedBuilds = true;

      buildMachines = [
        {
          hostName = "192.168.1.201";
          sshUser = "remotebuilder";
          sshKey = "/root/.ssh/remote_builder";

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
      IdentityFile          /root/.ssh/remote_builder
      IdentitiesOnly        yes
      StrictHostKeyChecking accept-new
    '';
  };
}
