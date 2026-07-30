{
  lib,
  config,
  pkgs,
  userName,
  ...
}:

let
  # autologin on tty7. Otherwise autologin and getty alternate in grabbing tty1 on nixos-rebuild switch
  autologin_on_tty7 = pkgs.autologin.overrideAttrs (_: {
    postPatch = /* sh */ ''
      substituteInPlace "main.c" \
        --replace-fail "setup_vt(1);" "setup_vt(7);" \
        --replace-fail "XDG_VTNR=1" "XDG_VTNR=7"
    '';
  });

  cfg = config.modules.core.services.niri-autologin;
  hmCfg = config.home-manager.users.${userName}.modules.user;
in
{
  options = {
    modules.core.services.niri-autologin = {
      enable = lib.mkEnableOption "custom niri autologin service" // {
        default = hmCfg.desktop.niri.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # https://git.sr.ht/~kennylevinsen/autologin
    environment.systemPackages = [ autologin_on_tty7 ];

    systemd.services."autologin" = {
      enable = true;
      restartIfChanged = lib.mkForce false;
      description = "Autologin";
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
      ];

      serviceConfig = {
        ExecStart = /* sh */ ''
          ${autologin_on_tty7}/bin/autologin \
                ${userName} ${pkgs.niri}/bin/niri-session 2>/dev/null'';
        Type = "simple";
        IgnoreSIGPIPE = "no";
        SendSIGHUP = "yes";
        TimeoutStopSec = "30s";
        KeyringMode = "shared";
        Restart = "always";
        RestartSec = "10";
      };
      startLimitBurst = 5;
      startLimitIntervalSec = 30;
      aliases = [ "display-manager.service" ];
      wantedBy = [ "multi-user.target" ];
    };

    security.pam.services."autologin" = {
      enable = true;
      name = "autologin";
      startSession = true;
      setLoginUid = true;
      updateWtmp = true;
    };
  };
}
