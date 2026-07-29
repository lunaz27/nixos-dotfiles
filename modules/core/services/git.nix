{
  lib,
  config,
  userName,
  userEmail,
  ...
}:

let
  cfg = config.modules.core.services.git;
in
{
  options = {
    modules.core.services.git = {
      enable = lib.mkEnableOption "git options" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      config = {
        user = {
          name = userName;
          email = userEmail;
        };

        init.defaultBranch = "master";
      };
    };
  };
}
