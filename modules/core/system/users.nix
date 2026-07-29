{
  lib,
  config,
  hostList,
  userName,
  ...
}:

let
  cfg = config.modules.core.system.users;
in
{
  options = {
    modules.core.system.users = {
      enable = lib.mkEnableOption "users declaration" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      hashedPasswordFile = config.sops.secrets."normal-user".path;
      openssh.authorizedKeys.keyFiles = map (host: ../../../public/ssh-keys/id_${host}.pub) hostList;
    };
  };
}
