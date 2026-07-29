{
  lib,
  config,
  userName,
  ...
}:

let
  cfg = config.modules.core.services.tty-autologin;
in
{
  options = {
    modules.core.services.tty-autologin = {
      enable = lib.mkEnableOption "default pkg that automatically goes into tty for \${USER}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.getty = {
      enable = true;
      autologinUser = "${userName}";
      # greetingLine = /* txt */ ''
      #
      # '';
    };
  };
}
