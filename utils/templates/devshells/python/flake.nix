{
  description = "Python (Devshell)";

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
          devshells."python" = {
            name = "Python";

            packages = with pkgs; [
              entr
              fd
              just
              lefthook

              pyright
              ruff

              (python3.withPackages (
                python-pkgs: with python-pkgs; [
                  debugpy

                  pytest
                  pytest-cov
                  pytest-instafail
                  pytest-md-report
                  # pytest-sugar
                  # pytest-mock
                ]
              ))
            ];

            commands = [
              {
                name = "kickstart";
                command = "git init && lefthook install";
                help = "install git hooks";
              }
            ];

            devshell.motd = ''
               {45}Welcome to Python.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
