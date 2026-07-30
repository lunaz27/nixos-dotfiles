{
  lib,
  config,
  userName,
  ...
}:

let
  inherit (lib) mkForce;

  cfg = config.modules.specialisation.server;
in
{
  options = {
    modules.specialisation.server = {
      enable = lib.mkEnableOption "dedicated specialisation for running servers (e.g., minecraft-server)";
    };
  };

  config = lib.mkIf cfg.enable {
    specialisation."Server" = {
      configuration = {
        system.nixos.tags = [ "Server" ];

        modules.core = {
          hardware = {
            msi.ec = {
              webcamBlock = mkForce true;
              kbdBacklight = mkForce 0;
            };

            nvidia-offload.enable = mkForce false;
            nvidia-disable.enable = mkForce true;
          };

          services = {
            niri-autologin.enable = mkForce false;
            tty-autologin.enable = mkForce true;
            logind.ignoreLidClosing = mkForce true;
            minecraft-server.enable = mkForce true;
            tailscale.enable = mkForce true;
          };

          system = {
            kernel-zen.enable = mkForce false;
            kernel-cachyos = {
              enable = mkForce true;
              optimisationLevel = mkForce "v4";
            };
          };
        };

        home-manager.users.${userName}.modules.user = {
          apps = {
            anki.enable = mkForce false;
            libre-office.enable = mkForce false;
            librewolf.enable = mkForce false;
            only-office.enable = mkForce true;
            sioyek.enable = mkForce false;
            zathura.enable = mkForce false;
            zen-browser.enable = mkForce false;
          };

          cli = {
            bat.enable = mkForce false;
            btop.enable = mkForce false;
            cava.enable = mkForce false;
            comma.enable = mkForce false;
            fastfetch.enable = mkForce false;
            fzf.enable = mkForce false;
            herdr.enable = mkForce false;
            lazygit.enable = mkForce false;
            ssh-agent.enable = mkForce false;
            ssh-client.enable = mkForce true;
            tealdeer.enable = mkForce false;
            tmux.enable = mkForce false;
            yazi.enable = mkForce false;
          };

          desktop = {
            cursor.enable = mkForce false;
            fcitx5.enable = mkForce false;
            gtk.enable = mkForce false;
            niri.enable = mkForce false;
            noctalia.enable = mkForce false;
            qt.enable = mkForce false;
            sway.enable = mkForce false;
            user-dirs.enable = mkForce false;
          };

          dotfiles = {
            symlink.enable = mkForce false;
          };

          editors = {
            neovim.enable = mkForce false;
          };

          shells = {
            direnv.enable = mkForce false;
            entr.enable = mkForce false;
            eza.enable = mkForce false;
            fd.enable = mkForce false;
            fish.enable = mkForce false;
            ripgrep.enable = mkForce false;
            starship.enable = mkForce false;
            zoxide.enable = true;
          };

          terminals = {
            alacritty.enable = false;
            kitty.enable = mkForce false;
          };

          themes = {
            catppuccin.enable = mkForce false;
          };
        };
      };
    };
  };
}
