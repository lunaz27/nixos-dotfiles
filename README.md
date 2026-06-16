# NixOS Dotfiles

<!--toc:start-->

- [NixOS Dotfiles](#nixos-dotfiles)
  - [Personal notes](#personal-notes)
    - [Devshell](#devshell)
    - [Disko](#disko)
  - [NixOS Logo](#nixos-logo)
  <!--toc:end-->

## Personal notes

### Devshell

- Available templates:

  | Status |      Language      | Template Name |
  | :----: | :----------------: | :-----------: |
  |   OK   |        `C`         |       c       |
  |   OK   |       `C++`        |      cpp      |
  |   OK   |      `LaTeX`       |     latex     |
  |   OK   |  `Motion Canvas`   | motion-canvas |
  |   OK   |      `Python`      |    python     |
  | _WIP_  | `(System) Verilog` |    verilog    |
  | _WIP_  |      `Octave`      |    octave     |

- Initialize a **language template** with `devshell` environment, e.g.:

```fish
# With laptop host:
# .../<c-project-directory>
## Shell abbreviation: `nfitr` (local ~/nixos-dotfiles)
nix flake init -t ~/nixos-dotfiles/hosts/laptop#c

## Shell abbreviation: `nfitl` (current repository)
nix flake init -t github:suwapotta/nixos-dotfiles/hosts/laptop#c
```

- **Configuration**: `./modules/flake-utils/templates.nix` and `./devshells/*`
- [Documentation URL](https://flake.parts/options/devshell)

### Disko

- **Configuration**: `./modules/_disko`
- [Documentation URL](urlhttps://github.com/nix-community/disko/blob/master/docs/quickstart.md)

## NixOS Logo

![**NixOS** Distro logo](./images/logos/nixos-text.png)
