{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.programs.enable = lib.mkEnableOption "global programs";
  };

  config = lib.mkIf config.modules.core.programs.enable {
    programs = {
      # Linking binaries for lazyvim
      nix-ld.enable = true;

      # Required for home-manager to start-up (System Management tool)
      dconf.enable = true;
    };
  };
}
