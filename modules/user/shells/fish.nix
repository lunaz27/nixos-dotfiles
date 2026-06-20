{
  flake.homeModules."fish" =
    {
      config,
      ...
    }:

    let
      mkFunction = functionName: {
        body = builtins.readFile (../../../config/fish + "/${functionName}.fish");
      };
    in
    {
      home.sessionVariables = {
        MANPAGER = "env NVIM_APPNAME=lvim nvim +Man!";
        EZA_COLORS = "*.txt=35:*.md=35:*.kdl=33:*.sv=33";
      };

      programs.fish = {
        enable = true;

        completions = {
          just = "JUST_COMPLETE=fish just | source";
        };

        shellAliases = {
          lvim = "NVIM_APPNAME=lvim nvim";
          nix-just = "just -f ${config.home.homeDirectory}/nixos-dotfiles/Justfile";
          clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
          ll = "eza --icons -lh";
          ls = "eza --icons";
          la = "eza --icons -a";
          lla = "eza --icons -lha";
        };

        shellAbbrs = {
          nvimc = "nvim --clean";
          gi = "git init";
          gs = "git status";
          ga = "git add";
          gaa = "git add -A";
          gd = "git diff";
          gc = "git clone";
          gcm = "git commit -m";
          gp = "git push -v";
          gb = "git branch";
          gpl = "git pull";
          grc = "git reset --hard; git clean --force";
          lg = "lazygit";
          nr = "nix repl";
          ne = "nix eval";
          nd = "nix develop";
          nso = "nix store optimise";
          ni = "nix-instantiate";
          nie = "nix-instantiate --eval";
          nies = "nix-instantiate --eval --strict";
          nfu = "nix flake update";
          nlg = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
          nsp = "nix-shell --run \"fish\" -p";
          nrp = "nix run nixpkgs#";
          nfitr = "nix flake init -t github:suwapotta/nixos-dotfiles/hosts/laptop#";
          nfitl = "nix flake init -t ~/nixos-dotfiles/hosts/laptop#";
          noi = "nh os info";
          nrf = "nh os repl -H";
          ns = "nh search";
          nca = "nh clean all --keep 3";
          dac = "direnv allow .";
          dbc = "direnv block .";
          drc = "direnv reload .";
          ze = "zoxide edit";
          noc = "nixos-container";
          j = "just";
          nj = "nix-just";
          lh = "lefthook";
        };

        # shellInit = ''
        # '';

        interactiveShellInit = ''
          # No greeting
          set -g fish_greeting

          # sudo prompt
          set -gx SUDO_PROMPT (set_color -u -o red)"[sudo]"(set_color -u cyan) "Enter password %p:  "(set_color normal)

          # tmux + starship integration
          if not set -q TMUX
            if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
              cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
            end
          end
        '';

        functions = {
          bind_bang = mkFunction "bind_bang";
          bind_dollar = mkFunction "bind_dollar";
          starship_transient_prompt_func = mkFunction "starship_transient_prompt_func";
          fish_user_key_bindings = mkFunction "fish_user_key_bindings";
          yank_to_clipboard = mkFunction "yank_to_clipboard";
        };
      };
    };
}
