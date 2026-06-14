local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("luasnip", {
    t({
      'local ls = require("luasnip")',
      "local s = ls.snippet",
      "local t = ls.text_node",
      "local i = ls.insert_node",
      "",
      "return {",
      "  ",
    }),
    i(1, "snippet"),
    t({
      "",
      "}",
    }),
  }),

  s("asnippet", {
    t('s("'),
    i(1, "node_name"),
    t({ '", {', "\t" }),
    i(2, "node_content"),
    t({ "", "}" }),
  }),
}
