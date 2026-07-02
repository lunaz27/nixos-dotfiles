{
  flake.homeModules."neovim" =
    {
      pkgs,
      ...
    }:

    {
      home.packages = with pkgs; [
        # Core
        neovim

        # Dependencies
        (python314.withPackages (qs: with qs; [ pynvim ]))
        # chafa
        imagemagick
        sqlite
        trash-cli
        tree-sitter
        xdg-utils

        # LSPs/Formatters/Linters
        ## Lua
        lua-language-server
        stylua

        ## Nix
        nixd
        nixfmt
        statix

        ## Bash
        bash-language-server
        bashdb
        shellcheck
        shfmt

        ## Markdown
        markdown-toc
        markdownlint-cli2
        marksman
        mermaid-cli
        prettier

        ## Just
        just-lsp

        ## Others (e.g., yaml, toml, etc.)
        codespell
        taplo
        yaml-language-server
        vscode-langservers-extracted
      ];
    };
}
