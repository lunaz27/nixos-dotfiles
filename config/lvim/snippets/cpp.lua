local ls = require("luasnip")
local lse = require("luasnip.extras.fmt")
local s = ls.snippet
local i = ls.insert_node
local fmt = lse.fmt

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

  s(
    "unusedpar",
    fmt(
      [[
      /* {} */
      ]],
      {
        i(1, "parameter"),
      }
    )
  ),
}
