local ls = require("luasnip")
local lse = require("luasnip.extras.fmt")
local extras = require("luasnip.extras")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local rep = extras.rep
local fmt = lse.fmt

-- Extract module path of current nix file
local function dyn_module_path()
  local path = vim.api.nvim_buf_get_name(0)

  local match = path:match(".*/modules/(.+)%.nix$") or path:match("^modules/(.+)%.nix$")
  local default = "path.to.module"
  if match then
    default = match:gsub("/", ".")
  end

  return sn(nil, { i(1, default) })
end

return {
  s(
    "mkLegacyModule",
    fmt(
      [[
    {
      lib,
      config,
      ...
    }:

    {
      options = {
        modules.<>.enable = lib.mkEnableOption "<>";
      };

      config = lib.mkIf config.modules.<>.enable {
        <>
      };
    }
    ]],
      {
        d(1, dyn_module_path),
        i(2, "desc"),
        rep(1),
        i(3, "option1 = true;"),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    "mkModule",
    fmt(
      [[
    {
      lib,
      config,
      ...
    }:

    let
      cfg = config.modules.<>;
    in
    {
      options = {
        modules.<> = {
          enable = lib.mkEnableOption "<>";

          <>
        };
      };

      config = lib.mkIf cfg.enable {
        <>
      };
    }
    ]],
      {
        d(1, dyn_module_path),
        rep(1),
        i(2, "desc"),
        i(3, "option2 = lib.mkOption { };"),
        i(4, "option3 = { };"),
      },
      { delimiters = "<>" }
    )
  ),

  s(
    "enableModule",
    fmt("modules.<>.enable = <>;", {
      d(1, dyn_module_path),
      c(2, {
        t("true"),
        t("false"),
      }),
    }, { delimiters = "<>" })
  ),

  s(
    "mkCfg",
    fmt(
      [[
      cfg = config.modules.{};
      ]],
      {
        d(1, dyn_module_path),
      }
    )
  ),

  s(
    "lang",
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
