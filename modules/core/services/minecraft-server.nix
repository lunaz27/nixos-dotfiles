{
  lib,
  config,
  pkgs,
  userName,
  hosts,
  ...
}:

let
  monifactoryWrappedBin = pkgs.writeShellScriptBin "minecraft-server" /* bash */ ''
    export PATH="${pkgs.jdk17_headless}/bin:$PATH"
    echo "-Xms4096M -Xmx8192M -XX:+UseG1GC" > user_jvm_args.txt
    if [ -f "./run.sh" ]; then
      exec ${pkgs.bash}/bin/bash ./run.sh nogui
    else
      echo "ERROR: run.sh not found!"
      exit 1
    fi
  '';

  backupSrc = "${toString config.services.minecraft-server.dataDir}/";

  ipDest = "${userName}@" + hosts."desktop".ip + ":";
  backupDest =
    if !hmCfg.desktop.user-dirs.enable then
      ipDest + toString hmCfg.xdg.userDirs.publicShare + "/"
    else
      "${ipDest}/home/${userName}/Public/";

  cfg = config.modules.core.services.minecraft-server;
  hmCfg = config.home-manager.users.${userName}.modules.user;
in
{
  options = {
    modules.core.services.minecraft-server = {
      enable = lib.mkEnableOption "nixos native hosting server for minecraft";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.core.system._unfree-pkgs.list = [
      "minecraft-server"
    ];

    services.minecraft-server = {
      enable = true;
      package = monifactoryWrappedBin;
      jvmOpts = "";
      # jvmOpts = "-Xms2048M -Xmx2048M";

      eula = true;
      openFirewall = true;
      declarative = true;
      serverProperties = {
        server-port = 45000;
        difficulty = 0; # Force peaceful
        max-players = 2;
        motd = "NixOS Monifactory Hard mode (1.20.1) server!";
        allow-cheats = true;
        online-mode = false;
        allow-flight = true;
        max-tick-time = -1;
      };
    };

    programs.bash = {
      loginShellInit = /* bash */ ''
        if [[ "$(tty)" = "/dev/tty1" ]]; then
          ${pkgs.systemd}/bin/journalctl -fu minecraft-server.service
        fi
      '';
    };

    # TODO: Complete this automatic backup service
    # systemd = {
    #   services."minecraft-backup" = {
    #     description = "Backup Minecraft Server Data";
    #     serviceConfig = {
    #       Type = "oneshot";
    #       User = "root";
    #       ExecStart = /* sh */ ''
    #         ${pkgs.rsync}/bin/rsync -az --delete --partial ${backupSrc} ${backupDest}
    #       '';
    #       RemainAfterExit = true;
    #     };
    #   };
    #
    #   timers."minecraft-backup" = {
    #     wantedBy = [ "timers.target" ];
    #     timerConfig = {
    #       Persistent = true;
    #       # Verify by: $ systemd-analyze calendar --iterations 5 "*-*-* 00/1:00:00"
    #       OnCalendar = "*-*-* 00/1:00:00";
    #       Unit = "minecraft-server";
    #     };
    #   };
    # };
  };
}
