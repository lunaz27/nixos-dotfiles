{
  description = "Octave (Devshell)";

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
          devshells."octave" = {
            name = "octave";

            packages = with pkgs; [
              octave
              # octaveFull

              # matlab-language-server
              ruff
              pyright
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

            devshell.motd = ''
               {45}Welcome to GNU Octave.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
