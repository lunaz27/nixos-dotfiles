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
          ];

          makePkgs = with pkgs; [
            gnumake
            valgrind

            bear
            criterion
          ];

          mesonPkgs = with pkgs; [
            meson
            ninja

            mesonlsp

            pkg-config

            gcovr
            (writeShellScriptBin "gcov" /* sh */ ''
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
            "c-make" = mkDevShell {
              name = "C with Make";
              packages = basePkgs ++ makePkgs ++ pytestPkgs;
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
                 {45}Welcome to C.{reset}
                Enter 'menu' for general commands.
              '';
            };

            "c-meson" = mkDevShell {
              name = "C with Meson";
              packages = basePkgs ++ mesonPkgs;
              env = [
                {
                  name = "PKG_CONFIG_PATH";
                  value = "${pkgs.criterion.dev}/lib/pkgconfig";
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
                 {45}Welcome to C.{reset}
                Enter 'menu' for general commands.
              '';
            };
          };
        };
    };
}
