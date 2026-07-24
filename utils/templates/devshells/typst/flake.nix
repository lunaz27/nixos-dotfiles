{
  description = "Typst (Devshell)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    devshell.url = "github:numtide/devshell";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];

      systems = [ "x86_64-linux" ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:

        let
          stablePkgs = import inputs.nixpkgs-stable { inherit system; };
        in
        {
          devshells."typst" = {
            name = "Typst";

            packages = with pkgs; [
              lefthook
              just
              fd
              zathura
              yaml-language-server

              typst
              typstyle
              # NOTE: Waiting for plugin upstream fix
              stablePkgs.tinymist
              # websocat
            ];

            commands = [
              {
                name = "kickstart";
                command = "mkdir -v images/ && git init && lefthook install";
                help = "initialize git repository and hooks";
              }
            ];

            devshell.motd = ''
               {45}Welcome to Typst.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
