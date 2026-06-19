return {
  "L3MON4D3/LuaSnip",

  opts = {
    update_events = "TextChanged,TextChangedI",
  },

  config = function(_, opts)
    local ls = require("luasnip")

    ls.setup(opts)
    ls.filetype_extend("just", { "sh" })

    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
}
