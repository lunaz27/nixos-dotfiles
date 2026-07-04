local ls = require("luasnip")
local lse = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local rep = extras.rep
local fmt = lse.fmt

return {
  s(
    "mkModule",
    fmt(
      [[
    {
      lib,
      config,
      ...
    }:

    {
      options = {
        <>.enable = lib.mkEnableOption "enables <>";
      };

      config = lib.mkIf config.<>.enable {
        <>
      };
    }
    ]],
      {
        i(1, "moduleName"),
        rep(1),
        rep(1),
        i(2, "option1 = true;"),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    "useModule",
    fmt("<>.enable = <>;", {
      i(1, "moduleName"),
      c(2, {
        t("true"),
        t("false"),
      }),
    }, { delimiters = "<>" })
  ),
}
