{
  lib,
  config,
  ...
}:

{
  options = {
    modules.user.apps.librewolf.enable = lib.mkEnableOption "privacy enhanced firefox fork";
  };

  config = lib.mkIf config.modules.user.apps.librewolf.enable {
    programs.librewolf = {
      enable = true;

      # Enable WebGL, cookies and history
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };
    };
  };
}
