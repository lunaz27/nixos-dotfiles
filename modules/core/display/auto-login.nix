{
  lib,
  config,
  pkgs,
  ...
}:

let
  # autologin on tty7y. Otherwise autologin and getty alternate in grabbing tty1 on nixos-rebuild switch
  autologin_on_7 = pkgs.autologin.overrideAttrs (_: {
    postPatch = ''
      substituteInPlace "main.c" \
        --replace-fail "setup_vt(1);" "setup_vt(7);" \
        --replace-fail "XDG_VTNR=1" "XDG_VTNR=7"
    '';
  });
in
{
  options = {
    modules.core.auto-login.enable = lib.mkEnableOption "niri autologin";
  };

  config = lib.mkIf config.modules.core.auto-login.enable {
    # https://git.sr.ht/~kennylevinsen/autologin
    environment.systemPackages = [ autologin_on_7 ];

    systemd.services.autologin = {
      enable = true;
      restartIfChanged = lib.mkForce false;
      description = "Autologin";
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
      ];

      serviceConfig = {
        ExecStart = "${autologin_on_7}/bin/autologin suwapotta ${pkgs.niri}/bin/niri-session";
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

    security.pam.services.autologin = {
      enable = true;
      name = "autologin";
      startSession = true;
      setLoginUid = true;
      updateWtmp = true;
    };
  };
}
