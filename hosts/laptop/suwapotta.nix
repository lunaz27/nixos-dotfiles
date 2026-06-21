{
  self,
  lib,
  config,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";

  # Standard ~/.config/ directories
  configs = [
    "lvim"
    "niri"
    "nvim"
  ];
in
{
  home = {
    username = "suwapotta";
    homeDirectory = "/home/suwapotta";
    stateVersion = "25.11";
  };

  # Interates to make-out-of-store symlink from existing dotfiles
  xdg.configFile = lib.genAttrs configs (name: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
    recursive = true;
  });

  imports = [
    ### apps
    self.homeModules."anki"
    # self.homeModules."libre-office"
    self.homeModules."only-office"
    self.homeModules."zathura"
    self.homeModules."zen-browser"

    ### cli
    self.homeModules."bat"
    self.homeModules."btop"
    self.homeModules."cava"
    self.homeModules."fastfetch"
    self.homeModules."fzf"
    self.homeModules."lazygit"
    self.homeModules."tealdeer"
    # self.homeModules."tmux"
    self.homeModules."yazi"

    ### desktop
    self.homeModules."cursor"
    self.homeModules."fcitx5"
    self.homeModules."gtk"
    self.homeModules."niri-flake"
    # self.homeModules."noctalia-v4"
    self.homeModules."noctalia-v5"
    self.homeModules."qt"
    self.homeModules."user-dirs"

    ### editors
    self.homeModules."neovim"

    ### shells
    self.homeModules."direnv"
    self.homeModules."entr"
    self.homeModules."eza"
    self.homeModules."fd"
    self.homeModules."fish"
    self.homeModules."ripgrep"
    self.homeModules."starship"
    self.homeModules."zoxide"

    ### terminals
    self.homeModules."kitty"

    ### themes
    self.homeModules."catppuccin"
  ];
}
