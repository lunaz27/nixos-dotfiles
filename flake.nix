{
  description = "Fully modularized NixOS configuration";

  inputs = {
    # ── Nixpkgs ───────────────────────────────────────────────────────────────────
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ── Utils ─────────────────────────────────────────────────────────────────────
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Essentials ────────────────────────────────────────────────────────────────
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:

    let
      # Flake host infos declaration
      hosts = {
        desktop = {
          arch = "x86_64-linux";
          maxJobs = 32;
          speedFactor = 300;
          ip = "100.0.0.1"; # Temp
          isBuilder = true;
        };

        homeserver = {
          arch = "x86_64-linux";
          maxJobs = 4;
          speedFactor = 100;
          ip = "100.103.178.32";
          isBuilder = false;
        };

        laptop = {
          arch = "x86_64-linux";
          maxJobs = 12;
          speedFactor = 200;
          ip = "100.103.120.77";
          isBuilder = true;
        };
      };

      # Global variables
      hostList = builtins.attrNames hosts;
      userName = "lunaz";
      userEmail = "nguyenducthientan09@gmail.com";
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs (
        host: hostConfig:
        nixpkgs.lib.nixosSystem {
          system = hostConfig.arch;
          specialArgs = {
            inherit
              inputs
              hosts
              hostList
              userName
              userEmail
              ;
            hostName = host;
          };

          modules = [
            ./hosts/${host}/configuration.nix
          ];
        }
      ) hosts;

      templates = import ./modules/flake-utils/templates.nix;
    };
}
