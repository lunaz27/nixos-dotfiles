{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.nix.vm-variant.enable = lib.mkEnableOption "basic vm";
  };

  config = lib.mkIf config.modules.core.nix.vm-variant.enable {
    virtualisation.vmVariant = {
      users.extraUsers."vm-user" = {
        isNormalUser = true;

        extraGroups = [ "wheel" ];
        hashedPasswordFile = config.sops.secrets."vm-user".path;
      };
    };
  };
}
