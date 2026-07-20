return {
  "lervag/vimtex",

  lazy = true,
  ft = { "tex", "bib", "latex" },

  init = function()
    vim.g.vimtex_view_method = "sioyek"
    vim.g.vimtex_delim_toggle_mod_list = {
      { "\\left", "\\right" },
      { "\\big", "\\big" },
      { "\\Big", "\\Big" },
      { "\\bigg", "\\bigg" },
      { "\\Bigg", "\\Bigg" },
    }

    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-shell-escape",
      },
    }
  end,
}
