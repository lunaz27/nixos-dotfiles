return {
  "jmbuhr/otter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = "nix",

  opts = {},
  config = function(_, opts)
    local otter = require("otter")
    otter.setup(opts)
    otter.activate({ "bash", "sh", "lua" }, true, true, nil)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "nix",
      callback = function()
        otter.activate({ "bash", "sh", "lua" }, true, true, nil)
      end,
    })
  end,
}
