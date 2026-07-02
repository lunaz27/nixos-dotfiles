{
  flake.homeModules."lazygit" =
    {
      lib,
      ...
    }:

    {
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
          # showCommandLog = false;
          showBottomLine = false;
          nerdFontsVersion = "3";
        };
      };
    };
}
