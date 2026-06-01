{
  description = "Motion Canvas (Devshell)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:

        {
          devshells."motion-canvas" = {
            name = "Motion Canvas";

            packages = with pkgs; [
              nodejs
              vtsls
              biome

              ffmpeg

              vscode-langservers-extracted
            ];

            # commands = [
            #   {
            #     name = "kickstart";
            #     command = "npm init @motion-canvas@latest";
            #     help = "create Motion Canvas project";
            #   }
            # ];

            devshell.motd = ''
              󱖲 {45}Welcome to Motion Canvas.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
