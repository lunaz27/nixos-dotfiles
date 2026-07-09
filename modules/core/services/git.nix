{
  lib,
  config,
  ...
}:

{
  options = {
    modules.core.git.enable = lib.mkEnableOption "git options";
  };

  config = lib.mkIf config.modules.core.git.enable {
    programs.git = {
      enable = true;

      config = {
        user = {
          name = "suwapotta";
          email = "nguyenducthientan09@gmail.com";
        };

        init.defaultBranch = "master";
      };
    };
  };
}
