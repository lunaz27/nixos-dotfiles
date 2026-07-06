{
  lib,
  config,
  ...
}:

{
  options = {
    modules.user.cli.lazygit.enable = lib.mkEnableOption "lazygit - tui for git";
  };

  config = lib.mkIf config.modules.user.cli.lazygit.enable {
    programs.lazygit = {
      enable = true;

      settings = lib.mkForce {
        disableStartupPopups = true;
        notARepository = "skip";
        promptToReturnFromSubprocess = false;
        update.method = "never";

        git = {
          commit.signOff = true;
          parseEmoji = true;
        };

        showListFooter = false;
        showRandomTip = false;
        showBottomLine = false;
        nerdFontsVersion = "3";
      };
    };
  };
}
