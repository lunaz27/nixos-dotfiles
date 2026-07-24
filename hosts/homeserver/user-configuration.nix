# NOTE: Imported by ./home.nix

{
  modules.user = {
    apps = {
      anki.enable = false;
      libre-office.enable = false;
      librewolf.enable = true;
      only-office.enable = false;
      sioyek.enable = true;
      zathura.enable = false;
      zen-browser.enable = false;
    };

    cli = {
      bat.enable = false;
      btop = {
        enable = false;
        gpu = "none";
      };
      cava.enable = false;
      comma.enable = true;
      fastfetch.enable = false;
      fzf.enable = false;
      lazygit.enable = false;
      ssh-agent = {
        enable = false;
        useTPM = false;
        identityLifetimeSeconds = 8 * 60;
      };
      ssh-client.enable = true;
      tealdeer.enable = false;
      tmux.enable = false;
      yazi.enable = false;
    };

    desktop = {
      cursor.enable = false;
      fcitx5.enable = false;
      gtk.enable = false;
      niri-flake = {
        enable = false;
        release = "unstable";
      };
      noctalia.enable = false;
      qt.enable = false;
      sway.enable = true;
      user-dirs.enable = true;
    };

    dotfiles = {
      symlink = {
        enable = false;
        targets = [ ];
      };
    };

    editors = {
      neovim = {
        enable = true;
        bundleWithLsp = true;
      };
    };

    shells = {
      direnv.enable = false;
      entr.enable = false;
      eza.enable = false;
      fd.enable = false;
      fish.enable = false;
      ripgrep.enable = false;
      starship.enable = false;
      zoxide.enable = false;
    };

    terminals = {
      alacritty.enable = true;
      kitty.enable = false;
    };

    themes = {
      catppuccin.enable = false;
    };
  };
}
