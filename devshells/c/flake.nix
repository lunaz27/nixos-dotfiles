{
  description = "C (Devshell)";

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
          devshells."c" = {
            name = "C";

            packages = with pkgs; [
              entr
              fd
              gnumake
              just
              lefthook

              gcc
              clang-tools
              lldb
              bear
              criterion
              valgrind

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

            env = [
              {
                name = "NIX_CFLAGS_COMPILE";
                value = "-isystem ${pkgs.criterion.dev}/include";
              }
              {
                name = "CRITERION_INCLUDE";
                value = "${pkgs.criterion.dev}/include";
              }
              {
                name = "CRITERION_LIB";
                value = "${pkgs.criterion}/lib";
              }
            ];

            commands = [
              {
                name = "kickstart";
                command = "just bear && git init && lefthook install";
                help = "generate LSP bindings this project and install git hooks";
              }
            ];

            devshell.motd = ''
               {45}Welcome to C.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
