{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.remote-builder.enable = lib.mkEnableOption "nixos remote builder";
  };

  config = lib.mkIf config.modules.core.remote-builder.enable {
    users = {
      users."remotebuilder" = {
        isSystemUser = true;
        group = "remotebuilder";
        useDefaultShell = true;

        openssh.authorizedKeys.keyFiles = [
          ../../_ssh-keys/remote-build.pub
        ];
      };

      groups."remotebuilder" = { };
    };

    nix.settings.trusted-users = [ "remotebuilder" ];
  };
}
