{
  description = "LaTeX (Devshell)";

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
          devshells."latex" = {
            name = "LaTeX";

            packages = with pkgs; [
              zip
              fd
              just
              lefthook

              texliveFull
              (python3.withPackages (ps: [ ps.pygments ]))

              texlab
              bibtex-tidy
              textidote
              ghostscript
            ];

            commands = [
              {
                name = "kickstart";
                command = "git init && lefthook install";
                help = "initialize git repository and hooks";
              }
            ];

            devshell.motd = ''
               {45}Welcome to LaTeX.{reset}
              Enter 'menu' for general commands.
            '';
          };
        };
    };
}
