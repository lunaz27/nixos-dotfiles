return {
  {
    "nvim-treesitter/nvim-treesitter",

    opts = function(_, opts)
      opts.ensure_installed = {
        "arduino",
        "asm",
        "bash",
        "bibtex",
        "c",
        "cpp",
        "css",
        "fish",
        "gitignore",
        "glsl",
        "html",
        "javascript",
        "json",
        "just",
        "kdl",
        "kitty",
        "latex",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "meson",
        "nix",
        "python",
        "regex",
        "rust",
        "scss",
        "svelte",
        "systemverilog",
        "tmux",
        "toml",
        "tsx",
        "typst",
        "typst",
        "udev",
        "vim",
        "vue",
        "yaml",
        "zsh",
      }

      if type(opts.highlight) == "table" and type(opts.highlight.disable) == "table" then
        opts.highlight.disable = vim.tbl_filter(function(lang)
          return lang ~= "latex"
        end, opts.highlight.disable)
      end
    end,
  },
}
