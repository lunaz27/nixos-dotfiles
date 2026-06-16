return {
  "stevearc/conform.nvim",

  opts = function(_, opts)
    opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
      cpp = { "clang-format" },
      c = { "clang-format" },
      python = { "ruff_format" },
      verilog = { "verible" },
      systemverilog = { "verible" },
      tex = { "latexindent" },
      bib = { "bibtex-tidy" },
      yaml = { "prettier" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      just = { "just" },
      meson = { "meson" },
      -- rust = { "rustfmt" },
      -- kdl = { "kdlfmt" },

      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    })

    return opts
  end,
}
