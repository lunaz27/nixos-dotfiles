{
  inputs,
  ...
}:

{
  # NOTE: Imported by ./home.nix

  imports = [
    inputs.nix-index-database.homeModules.default
  ];

  programs = {
    nix-index = {
      enable = true;

      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    nix-index-database.comma = {
      enable = true;
    };
  };

  modules.user = {
    apps = {
      anki.enable = true;
      libre-office.enable = false;
      librewolf.enable = false;
      only-office.enable = true;
      sioyek.enable = true;
      zathura.enable = false;
      zen-browser.enable = true;
    };

    cli = {
      bat.enable = true;
      btop = {
        enable = true;
        gpu = "amd";
      };
      cava.enable = false;
      fastfetch.enable = true;
      fzf.enable = true;
      lazygit.enable = true;
      ssh-agent = {
        enable = true;
        useTPM = false;
        identityLifetimeSeconds = 8 * 60;
      };
      ssh-client.enable = true;
      tealdeer.enable = true;
      tmux.enable = false;
      yazi.enable = true;
    };

    desktop = {
      cursor.enable = true;
      fcitx5.enable = true;
      gtk.enable = true;
      niri-flake = {
        enable = true;
        release = "unstable";
      };
      noctalia.enable = true;
      qt.enable = true;
      sway.enable = false;
      user-dirs.enable = true;
    };

    dotfiles = {
      symlink = {
        enable = true;
        targets = [
          "niri"
          "lvim"
        ];
      };
    };

    editors = {
      neovim = {
        enable = true;
        bundleWithLsp = false;
      };
    };

    shells = {
      direnv.enable = true;
      entr.enable = false;
      eza.enable = true;
      fd.enable = true;
      fish.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      zoxide.enable = true;
    };

    terminals = {
      alacritty.enable = false;
      kitty.enable = true;
    };

    themes = {
      catppuccin.enable = true;
    };
  };
}
