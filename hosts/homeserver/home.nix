{
  inputs,
  hostList,
  hostName,
  hosts,
  userEmail,
  userName,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit
        inputs
        hostList
        hostName
        hosts
        userEmail
        userName
        ;
    };
    backupFileExtension = "bak";
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    users."${userName}" = {
      imports = [
        # ── Modules ───────────────────────────────────────────────────────────────────
        ../../modules/user/user-default.nix
      ];

      home = {
        stateVersion = "26.05";
        username = "${userName}";
        homeDirectory = "/home/${userName}";
      };

      sops = {
        defaultSopsFile = ../../secrets/user-level/ssh-keys.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
      };

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
            useMinimalConfig = true;
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
    };
  };
}
