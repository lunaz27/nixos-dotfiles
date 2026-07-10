{
  lib,
  config,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/modules/user/dotfiles/config";
  cfg = config.modules.user.dotfiles.symlink;
in
{
  options = {
    modules.user.dotfiles.symlink = {
      enable = lib.mkEnableOption "enables Out-Of-Store-Symlink";
      targets = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # NOTE: Target standard ~/.config/ directories
    # Interates to make-out-of-store symlink from existing dotfiles
    xdg.configFile = lib.genAttrs cfg.targets (name: {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
      recursive = true;
    });
  };
}
