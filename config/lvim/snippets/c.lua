local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "bcomment",
    fmt(
      [[
    /*
     * {}
     */
  ]],
      {
        i(1, "Description"),
      }
    )
  ),
}
