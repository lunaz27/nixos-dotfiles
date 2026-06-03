{
  flake.nixosModules."variables" =
    let
      lvim = "env NVIM_APPNAME=lvim nvim";
    in
    {
      environment = {
        # Override defaultEditor option
        variables = {
          EDITOR = lvim;
          VISUAL = lvim;
        };

        sessionVariables = {
          # fcitx5 variables
          XMODIFIERS = "@im=fcitx";
          MOZ_ENABLE_WAYLAND = "1";
          GLFW_IM_MODULE = "ibus";

          LIBVA_DRIVER_NAME = "iHD";
        };
      };
    };
}
