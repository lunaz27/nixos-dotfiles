{
  lib,
  config,
  pkgs,
  ...
}:

let
  monifactoryWrapped = pkgs.writeShellScriptBin "minecraft-server" ''
    export PATH="${pkgs.jdk17_headless}/bin:$PATH"
    echo "-Xms4096M -Xmx8192M -XX:+UseG1GC" > user_jvm_args.txt
    if [ -f "./run.sh" ]; then
      exec bash ./run.sh
    else
      echo "ERROR: run.sh not found!"
      exit 1
    fi
  '';

  cfg = config.modules.core.services.minecraft-server;
in
{
  options = {
    modules.core.services.minecraft-server = {
      enable = lib.mkEnableOption "nixos native hosting server for minecraft";
    };
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      package = monifactoryWrapped;
      jvmOpts = "";
      # jvmOpts = "-Xms2048M -Xmx2048M";

      eula = true;
      openFirewall = true;
      declarative = true;
      serverProperties = {
        server-port = 45000;
        difficulty = 0; # Force peaceful
        max-players = 3;
        motd = "NixOS Monifactory Hard mode (1.20.1) server!";
        allow-cheats = true;
        online-mode = false;
        allow-flight = true;
        max-tick-time = -1;
      };
    };

    modules.core.system._unfree-pkgs.list = [
      "minecraft-server"
    ];
  };
}
