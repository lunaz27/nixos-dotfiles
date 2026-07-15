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
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    users."lunaz" = {
      imports = [
        # ── Modules ───────────────────────────────────────────────────────────────────
        ../../modules/user/user-default.nix
      ];

      home = {
        stateVersion = "26.05";
        username = "lunaz";
        homeDirectory = "/home/lunaz";
      };

      sops = {
        defaultSopsFile = ../../../secrets/sshKeys.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = "/home/lunaz/.config/sops/age/keys.txt";
      };

      modules.user = {
        apps = {
          anki.enable = false;
          libre-office.enable = false;
          librewolf.enable = true;
          only-office.enable = false;
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
          fastfetch.enable = true;
          fzf.enable = false;
          lazygit.enable = true;
          ssh-agent = {
            enable = false;
            useTPM = false;
            identityLifetimeSeconds = 8 * 60;
          };
          ssh-client = {
            enable = true;
            keyGen = "rig";
          };
          tealdeer.enable = false;
          tmux.enable = false;
          yazi.enable = false;
        };

        desktop = {
          cursor.enable = true;
          fcitx5.enable = true;
          gtk.enable = false;
          niri-flake = {
            enable = false;
            release = "unstable";
          };
          noctalia.enable = false;
          qt.enable = false;
          user-dirs.enable = true;
        };

        dotfiles = {
          symlink = {
            enable = true;
            targets = [
              "nvim"
            ];
          };
        };

        editors = {
          neovim.enable = true;
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
          kitty.enable = false;
        };

        themes = {
          catppuccin.enable = false;
        };
      };
    };
  };
}
