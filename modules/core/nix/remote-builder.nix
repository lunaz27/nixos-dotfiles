{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.nix.remote-builder.enable = lib.mkEnableOption "nixos remote builder";
  };

  config = lib.mkIf config.modules.core.nix.remote-builder.enable {
    users = {
      users."remotebuilder" = {
        isSystemUser = true;
        group = "remotebuilder";
        useDefaultShell = true;

        openssh.authorizedKeys.keyFiles = [
          ../../../public/ssh-keys/remote_build.pub
        ];
      };

      groups."remotebuilder" = { };
    };

    nix.settings.trusted-users = [ "remotebuilder" ];
  };
}
