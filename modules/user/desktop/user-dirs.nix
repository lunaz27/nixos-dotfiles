{
  lib,
  config,
  ...
}:

with config.home;
let
  folders = {
    desktop = "Desktop";
    documents = "Documents";
    download = "Downloads";
    music = "Music";
    pictures = "Pictures";
    projects = "Projects";
    publicShare = "Public";
    templates = "Templates";
    videos = "Videos";
  };

  mkDir = name: "${homeDirectory}/${name}";
in
{
  options = {
    modules.user.desktop.user-dirs.enable =
      lib.mkEnableOption "auto-create default dirs in /home/$USER";
  };

  config = lib.mkIf config.modules.user.desktop.user-dires.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;

      extraConfig = {
        PRIVATE = mkDir "Private";
        VIRTUALISATION = mkDir "Virtualisation";
      };
    }
    // builtins.mapAttrs (name: folder: "${homeDirectory}/${folder}") folders;
  };
}
