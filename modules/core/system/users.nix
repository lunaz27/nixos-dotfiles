{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.system.users.enable = lib.mkEnableOption "users declaration";
  };

  config = lib.mkIf config.modules.core.system.users.enable {
    users.users."lunaz" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      hashedPasswordFile = config.sops.secrets."normal-user".path;

      openssh.authorizedKeys.keyFiles = [
        ../../../public/ssh-keys/id_desktop.pub
        ../../../public/ssh-keys/id_laptop.pub
        ../../../public/ssh-keys/id_rig.pub
      ];
    };
  };
}
