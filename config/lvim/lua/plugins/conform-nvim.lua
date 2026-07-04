return {
  "stevearc/conform.nvim",

  opts = function(_, opts)
    opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
      asm = { "asmfmt" },
      bib = { "bibtex-tidy" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      just = { "just" },
      -- kdl = { "kdlfmt" },
      meson = { "meson" },
      python = { "ruff_format" },
      -- rust = { "rustfmt" },
      systemverilog = { "verible" },
      tex = { "latexindent" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      verilog = { "verible" },
      yaml = { "prettier" },

      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    })

    return opts
  end,
}
