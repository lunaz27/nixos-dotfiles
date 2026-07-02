{
  flake.homeModules."user-dirs" =
    {
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
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = false;

        extraConfig = {
          PRIVATE = mkDir "Private";
          VIRTUALISATION = mkDir "Virtualisation";
          # WORKSPACE = mkDir "Workspace";
        };
      }
      // builtins.mapAttrs (name: folder: "${homeDirectory}/${folder}") folders;
    };
}
