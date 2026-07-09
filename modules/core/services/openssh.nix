{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.openssh.enable = lib.mkEnableOption "ssh daemon";
  };

  config = lib.mkIf config.modules.core.openssh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      ports = [
        22
        24
      ];

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [
          "suwapotta"
          "remotebuilder"
        ];
        MaxAuthTries = 3;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };
  };
}
