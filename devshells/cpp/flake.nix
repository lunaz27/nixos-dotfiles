{
  description = "C++ (Devshell)";

  inputs = {
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
          devshells.default = {
            name = "C++";

            packages = with pkgs; [
              fd
              entr
              gnumake

              gcc
              clang-tools
              lldb
              bear
              gtest
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
                value = "-isystem ${pkgs.gtest.dev}/include";
              }
              {
                name = "GTEST_INCLUDE";
                value = "${pkgs.gtest.dev}/include";
              }
              {
                name = "GTEST_LIB";
                value = "${pkgs.gtest}/lib";
              }
            ];

            commands = [
              {
                name = "kickstart";
                command = "make bear";
                help = "generate LSP bindings this project through bear";
              }
              {
                name = "debug";
                command = builtins.readFile ./debugging.sh;
                help = "run make <mode> continuously";
              }
            ];

            devshell.motd = ''
               {45}Welcome to C++.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
