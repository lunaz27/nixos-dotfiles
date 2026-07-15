{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.services.git.enable = lib.mkEnableOption "git options";
  };

  config = lib.mkIf config.modules.core.services.git.enable {
    programs.git = {
      enable = true;

      config = {
        user = {
          name = "lunaz";
          email = "nguyenducthientan09@gmail.com";
        };

        init.defaultBranch = "master";
      };
    };
  };
}
