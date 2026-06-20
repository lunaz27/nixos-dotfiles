{
  description = "C++ (Devshell)";

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
        {
          pkgs,
          ...
        }:

        let
          basePkgs = with pkgs; [
            entr
            fd
            just
            lefthook

            gcc
            clang-tools
            lldb

            gtest
            gcovr
            (writeShellScriptBin "gcov" ''
              exec ${gcc.cc}/bin/gcov "$@"
            '')
          ];

          pytestPkgs = with pkgs; [
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

          makePkgs = with pkgs; [
            gnumake

            bear
            valgrind

          ];

          mesonPkgs = with pkgs; [
            meson
            ninja

            mesonlsp

            pkg-config
          ];

          mkDevShell =
            {
              name,
              packages,
              env,
              commands,
              motd,
            }:
            {
              inherit
                name
                packages
                env
                commands
                ;

              devshell.motd = motd;
            };
        in
        {
          devshells = {
            "cpp-make" = mkDevShell {
              name = "C++ with Make";
              packages = basePkgs ++ makePkgs ++ pytestPkgs;
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
                  command = ''
                    #!/usr/bin/env bash
                    set -euo pipefail
                    rm -rfv *.meson || true
                    for item in *.make; do
                      mv -v "$item" "''${item%.make}"
                    done
                    just bear && git init && lefthook install
                  '';
                  help = "generate LSP bindings this project and install git hooks";
                }
              ];
              motd = ''
                 {45}Welcome to C++.{reset}
                Enter 'menu' for general commands.
              '';
            };

            "cpp-meson" = mkDevShell {
              name = "C++ with Meson";
              packages = basePkgs ++ mesonPkgs;
              env = [
                {
                  name = "PKG_CONFIG_PATH";
                  value = "${pkgs.gtest.dev}/lib/pkgconfig";
                }
              ];
              commands = [
                {
                  name = "kickstart";
                  command = ''
                    #!/usr/bin/env bash
                    set -euo pipefail
                    rm -rfv *.make || true
                    for item in *.meson; do
                      mv -v "$item" "''${item%.meson}"
                    done
                    just configure && git init && lefthook install
                  '';
                  help = "generate LSP bindings this project and install git hooks";
                }
              ];
              motd = ''
                 {45}Welcome to C++.{reset}
                Enter 'menu' for general commands.
              '';
            };
          };
        };
    };
}
