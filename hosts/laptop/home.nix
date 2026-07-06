{
  inputs,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "bak";

    users."suwapotta" = {
      imports = [
        # ── Modules ───────────────────────────────────────────────────────────────────
        ../../modules/user/user-default.nix
      ];

      home = {
        stateVersion = "25.11";
        username = "suwapotta";
        homeDirectory = "/home/suwapotta";
      };

      modules.user = {
        apps = {
          anki.enable = true;
          libre-office.enable = false;
          only-office.enable = true;
          zathura.enable = true;
          zen-browser.enable = true;
        };

        cli = {
          bat.enable = true;
          btop.enable = true;
          cava.enable = false;
          fastfetch.enable = true;
          fzf.enable = true;
          lazygit.enable = true;
          tealdeer.enable = true;
          tmux.enable = false;
          yazi.enable = true;
        };

        desktop = {
          cursor.enable = true;
          fcitx5.enable = true;
          gtk.enable = true;
          niri-flake.enable = true;
          noctalia-v4.enable = false;
          noctalia-v5.enable = true;
          qt.enable = true;
          user-dirs.enable = true;
        };

        dotfiles = {
          symlink.enable = true;
        };

        editors = {
          neovim.enable = true;
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
          kitty.enable = true;
        };

        themes = {
          catppuccin.enable = true;
        };
      };
    };
  };
}
