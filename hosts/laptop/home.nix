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
        stateVersion = "25.11";
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
            gpu = "nvidia";
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
              # "lvim"
              "nvim"
            ];
          };
        };

        editors = {
          neovim = {
            enable = true;
            useMinimalConfig = false;
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
    };
  };
}
